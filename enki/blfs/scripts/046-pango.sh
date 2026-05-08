#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=pango-1.57.0
SOURCE=pango-1.57.0.tar.xz
URL=https://download.gnome.org/sources/pango/1.57/pango-1.57.0.tar.xz
MD5=c027445c1325603a2a11df2fd868e6b8

run_build () {
    rm -rf build
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr            \
            --buildtype=release      \
            --wrap-mode=nofallback   \
            -D introspection=enabled \
            ..                       &&
    ninja
}

run_test () {
    ninja test
}

run_install () {
    sudo ninja install
}

run_all
