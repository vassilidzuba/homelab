#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libpng-1.6.55
SOURCE=libpng-1.6.55.tar.xz
URL=https://downloads.sourceforge.net/libpng/libpng-1.6.55.tar.xz
MD5=bc950b5a06ec1028285e14a127f6fb6e

PATCH=libpng-1.6.54-apng.patch.gz

run_build () {
    if [ ! -f $PATCH ]; then
        cp $SHAREDDIR/PATCH $PATCH
    fi
    zcat ../libpng-1.6.54-apng.patch.gz | patch -p1

    ./configure --prefix=/usr --disable-static &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install &&
    sudo mkdir -v /usr/share/doc/libpng-1.6.55 &&
    sudo cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.55
}

run_all
