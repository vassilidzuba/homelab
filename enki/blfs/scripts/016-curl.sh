#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=curl-8.18.0
SOURCE=curl-8.18.0.tar.xz
URL=https://curl.se/download/curl-8.18.0.tar.xz
MD5=dae6088bf7af69d3b0a87c762de92248

run_build () {
    ./configure --prefix=/usr    \
                --disable-static \
                --with-openssl   \
                --with-ca-path=/etc/ssl/certs &&
    make
}

run_test () {
    echo -n
}

run_install () {
    sudo make install &&

    sudo rm -rf docs/examples/.deps &&

    sudo find docs \( -name Makefile\* -o  \
                 -name \*.1       -o  \
                 -name \*.3       -o  \
                 -name CMakeLists.txt \) -delete &&

    sudo cp -v -R docs -T /usr/share/doc/curl-8.18.0
}

run_all
