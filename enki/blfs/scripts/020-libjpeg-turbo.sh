#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libjpeg-turbo-3.1.3
SOURCE=libjpeg-turbo-3.1.3.tar.gz
URL=https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.3/libjpeg-turbo-3.1.3.tar.gz
MD5=d23f3be7e58ad79d297845e64807472c

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
