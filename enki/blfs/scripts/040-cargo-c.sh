#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=cargo-c-0.10.20
SOURCE=cargo-c-0.10.20.tar.gz
URL=https://github.com/lu-zero/cargo-c/archive/v0.10.20/cargo-c-0.10.20.tar.gz
MD5=10c67f70802e70588c59260441812886

run_build () {
    curl -fLO https://github.com/lu-zero/cargo-c/releases/download/v0.10.20/Cargo.lock

    export LIBSSH2_SYS_USE_PKG_CONFIG=1    &&
    export LIBSQLITE3_SYS_USE_PKG_CONFIG=1 &&

    cargo build --release
}

run_test () {
    cargo test --release
}

run_install () {
    sudo install -vm755 target/release/cargo-{capi,cbuild,cinstall,ctest} /usr/bin/
    unset LIB{SSH2,SQLITE3}_SYS_USE_PKG_CONFIG
}

run_all
