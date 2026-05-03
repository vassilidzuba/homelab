#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=librsvg-2.61.4.tar.xz
SOURCE=librsvg-2.61.4.tar.xz
URL=https://download.gnome.org/sources/librsvg/2.61/librsvg-2.61.4.tar.xz
MD5=e9a1654bd98cda161933cc9ab85ee15b

run_build () {
    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr        \
          -D CMAKE_BUILD_TYPE=RELEASE         \
          -D ENABLE_STATIC=FALSE              \
          -D CMAKE_INSTALL_DEFAULT_LIBDIR=lib \
          -D CMAKE_SKIP_INSTALL_RPATH=ON      \
          -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-3.1.3 \
          .. &&
    make
}

run_test () {
    make test
}

run_install () {
    sudo make install
}

run_all
