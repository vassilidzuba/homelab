#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=gdk-pixbuf-2.44.5
SOURCE=gdk-pixbuf-2.44.5.tar.xz
URL=https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-2.44.5.tar.xz
MD5=1cde6bd5665107fa10d1deef32ec8c4c

run_build () {
    rm -rf build
    mkdir build &&
    cd    build &&

    meson setup ..                \
          --prefix=/usr           \
          --buildtype=release     \
          -D png=disabled         \
          -D gif=disabled         \
          -D jpeg=disabled        \
          -D tiff=disabled        \
          -D thumbnailer=disabled \
          --wrap-mode=nofallback  \
          $(pkgconf glycin-2 || echo -D glycin=disabled) &&
    ninja
}

run_test () {
    echo -n
}

run_install () {
    sudo ninja install
}

run_all
