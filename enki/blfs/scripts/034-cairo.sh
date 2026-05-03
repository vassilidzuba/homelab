#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=cairo-1.18.4
SOURCE=cairo-1.18.4.tar.xz
URL=https://www.cairographics.org/releases/cairo-1.18.4.tar.xz
MD5=db575fb41bbda127e0147e401f36f8ac

run_build () {
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release .. &&
    ninja
}

run_test () {
    echo -n
}

run_install () {
    sudo ninja install
}

run_all
