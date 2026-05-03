#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=pixman-0.46.4
SOURCE=pixman-0.46.4.tar.gz
URL=https://www.cairographics.org/releases/pixman-0.46.4.tar.gz
MD5=c08173c8e1d2cc79428d931c13ffda59

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
