#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libxml2-2.15.1
SOURCE=libxml2-2.15.1.tar.xz
URL=https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
MD5=fcf38f534bb8996984dba978ee3e27f4

run_build () {
    sed -i "/'git'/,+3d" meson.build

    mkdir build &&
    cd    build &&

    meson setup ..           \
        --prefix=/usr      \
        -D history=enabled \
        -D icu=enabled     &&
    ninja
}

run_test () {
    echo -n
}

run_install () {
    sudo ninja install &&

    sudo sed "s/--static/--shared/" -i /usr/bin/xml2-config
}

run_all
