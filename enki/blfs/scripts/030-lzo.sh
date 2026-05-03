#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=lzo-2.10
SOURCE=lzo-2.10.tar.gz
URL=https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz
MD5=39d3f3f9c55c87b1e5d6888e1420f4b5

run_build () {
    ./configure --prefix=/usr    \
                --enable-shared  \
                --disable-static \
                --docdir=/usr/share/doc/lzo-2.10 &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install
}

run_all
