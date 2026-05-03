#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=bubblewrap-0.11.0
SOURCE=bubblewrap-0.11.0.tar.xz
URL=https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz
MD5=630eec714ea04729efd116ea85a715a3

run_build () {
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release .. &&
    ninja
}

run_test () {
    sed 's@symlink usr/lib64@ro-bind-try /lib64@' -i ../tests/libtest.sh &&
    ninja test
}

run_install () {
    sudo ninja install
}

run_all
