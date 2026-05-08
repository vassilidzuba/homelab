#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=harfbuzz-12.3.2
SOURCE=harfbuzz-12.3.2.tar.xz
URL=https://github.com/harfbuzz/harfbuzz/releases/download/12.3.2/harfbuzz-12.3.2.tar.xz
MD5=10040432f566e50bda84bfba8ad80b8d

run_build () {
    mkdir build &&
    cd    build &&

    meson setup ..             \
          --prefix=/usr        \
          --buildtype=release  \
          -D graphite2=enabled &&
    ninja
}

run_test () {
    ninja test
}

run_install () {
    sudo ninja install
}

run_all
