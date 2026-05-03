#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=brotli-1.2.0
SOURCE=brotli-1.2.0.tar.gz
URL=https://github.com/google/brotli/archive/v1.2.0/brotli-1.2.0.tar.gz
MD5=8fbfae9a5ecbc278ae7f761ecb6d1285

run_build () {
    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr \
          -D CMAKE_BUILD_TYPE=Release  \
          -G Ninja .. &&
    ninja
}

run_test () {
    ninja test
}

run_install () {
    sudo ninja install
}

run_all
