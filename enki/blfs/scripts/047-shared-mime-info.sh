#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=shared-mime-info-2.4
SOURCE=shared-mime-info-2.4.tar.gz
URL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.gz
MD5=aac56db912b7b12a04fb0018e28f2f36

run_build () {
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release -D update-mimedb=true .. &&
    ninja
}

run_test () {
    echo -n
}

run_install () {
    sudo ninja install
}

run_all
