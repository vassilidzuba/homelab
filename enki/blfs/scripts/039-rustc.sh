#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=rustc-1.93.1-src
SOURCE=rustc-1.93.1-src.tar.xz
URL=https://static.rust-lang.org/dist/rustc-1.93.1-src.tar.xz
MD5=65de3c1b0a9304b16ff27433a0dafb95

run_build () {
    mkdir -pv /opt/rustc-1.93.1      &&
    ln -svfn rustc-1.93.1 /opt/rustc &&

cat << EOF > bootstrap.toml
# See bootstrap.toml.example for more possible options,
# and see src/bootstrap/defaults/bootstrap.dist.toml for a few options
# automatically set when building from a release tarball
# (unfortunately, we have to override many of them).

# Tell x.py that the editors have reviewed the content of this file
# and updated it to follow the major changes of the building system,
# so x.py will not warn users to review that information.
change-id = 148795

[llvm]
# When using the system installed copy of LLVM, prefer the shared libraries
link-shared = true

# If building the shipped LLVM source, only enable the x86 target
# instead of all the targets supported by LLVM.
targets = "X86"

[build]
description = "for BLFS 13.0"

# Omit the documentation to save time and space (the default is to build them).
docs = false

# Do not look for new versions of the dependencies online.
locked-deps = true

# Only install these extended tools. Cargo, clippy, rustdoc, and rustfmt
# are installed by a default rustup installation, and rust-src is needed
# to build the Rust code in Linux kernel (in case you need such a kernel
# feature).
tools = ["cargo", "clippy", "rustdoc", "rustfmt", "src"]

[install]
prefix = "/opt/rustc-1.93.1"
docdir = "share/doc/rustc-1.93.1"

[rust]
channel = "stable"

# Enable the same optimizations as the official upstream build.
lto = "thin"
codegen-units = 1

# Don't build llvm-bitcode-linker which is only useful for the NVPTX
# backend that we don't enable.
llvm-bitcode-linker = false

[target.x86_64-unknown-linux-gnu]
llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
llvm-config = "/usr/bin/llvm-config"
EOF

    export LIBSSH2_SYS_USE_PKG_CONFIG=1
    export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
    ./x.py build
}

run_test () {
    ./x.py test --verbose --no-fail-fast | tee rustc-testlog &&

    grep '^test result:' rustc-testlog |
        awk '{sum1 += $4; sum2 += $6} END { print sum1 " passed; " sum2 " failed" }'
}

run_install () {
    sudo --preserve-env=LIB{SSH2,SQLITE3}_SYS_USE_PKG_CONFIG ./x.py install &&

    sudo rm -fv /opt/rustc-1.93.1/share/doc/rustc-1.93.1/*.old   &&
    sudo install -vm644 README.md                                \
                   /opt/rustc-1.93.1/share/doc/rustc-1.93.1 &&

    sudo install -vdm755 /usr/share/zsh/site-functions      &&
    sudo ln -sfv /opt/rustc/share/zsh/site-functions/_cargo \
            /usr/share/zsh/site-functions

    sudo mv -v /etc/bash_completion.d/cargo /usr/share/bash-completion/completions &&

    unset LIB{SSH2,SQLITE3}_SYS_USE_PKG_CONFIG &&

    echo "DO NOT FORGET TO SET UP THE CONFIGURATION !"
}

run_all
