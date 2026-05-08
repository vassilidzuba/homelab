#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=fribidi-1.0.16
SOURCE=fribidi-1.0.16.tar.xz
URL=https://github.com/fribidi/fribidi/releases/download/v1.0.16/fribidi-1.0.16.tar.xz
MD5=333ad150991097a627755b752b87f9ff

run_build () {
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release .. &&
    ninja
}

run_test () {
    ninja test
}

run_install () {
    sudo ninja install
}

run_all
