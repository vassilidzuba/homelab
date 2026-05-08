#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=librsvg-2.61.4
SOURCE=librsvg-2.61.4.tar.xz
URL=https://download.gnome.org/sources/librsvg/2.61/librsvg-2.61.4.tar.xz
MD5=e9a1654bd98cda161933cc9ab85ee15b

run_build () {
    sed -e "/OUTDIR/s|,| / 'librsvg-2.61.4', '--no-namespace-dir',|" \
        -e '/output/s|Rsvg-2.0|librsvg-2.61.4|'                      \
        -i doc/meson.build

    rm -rf build
    mkdir build &&
    cd    build &&

    meson setup --prefix=/usr --buildtype=release .. &&
    ninja
}

run_test () {
    meson test -v
}

run_install () {
    sudo ninja install
}

run_all
