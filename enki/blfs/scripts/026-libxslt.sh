#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libxslt-1.1.45
SOURCE=libxslt-1.1.45.tar.xz
URL=https://download.gnome.org/sources/libxslt/1.1/libxslt-1.1.45.tar.xz
MD5=84bb3f6ba7f5ee98af5dcd72e828c73e

run_build () {
    ./configure --prefix=/usr    \
                --disable-static \
                --without-python \
                --docdir=/usr/share/doc/libxslt-1.1.45 &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install
}

run_all
