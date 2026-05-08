#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=glib-2.86.4
SOURCE=glib-2.86.4.tar.xz
URL=https://download.gnome.org/sources/glib/2.86/glib-2.86.4.tar.xz
MD5=f2233a826c952aaae42b4a61611a06a4

run_build () {
    cp $SHAREDDIR/glib-skip_warnings-1.patch $SRCDIR
    cp $SHAREDDIR/glib-2.86.4-upstream_fixes-1.patch $SRCDIR
    cp $SHAREDDIR/gobject-introspection-1.86.0.tar.xz $SRCDIR

    if [ -e /usr/include/glib-2.0 ]; then
        sudo rm -rf /usr/include/glib-2.0.old &&
        sudo mv -vf /usr/include/glib-2.0{,.old}
    fi

    patch -Np1 -i ../glib-2.86.4-upstream_fixes-1.patch

    mkdir build &&
    cd    build &&

    meson setup ..                  \
          --prefix=/usr             \
          --buildtype=release       \
          -D introspection=disabled \
          -D glib_debug=disabled    \
          -D man-pages=enabled      \
          -D sysprof=disabled       &&
    ninja

    ninja install

    tar xf ../../gobject-introspection-1.86.0.tar.xz &&

    meson setup gobject-introspection-1.86.0 gi-build \
                --prefix=/usr --buildtype=release     &&
    ninja -C gi-build
}

run_test () {
    ninja -C gi-build test
}

run_install () {
    sudo ninja -C gi-build install

    meson configure -D introspection=enabled &&
    ninja

    sudo ninja install
}

run_all
