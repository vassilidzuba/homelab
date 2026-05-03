#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libssh2-1.11.1
SOURCE=libssh2-1.11.1.tar.gz
URL=https://www.libssh2.org/download/libssh2-1.11.1.tar.gz
MD5=38857d10b5c5deb198d6989dacace2e6

run_build () {
    ./configure --prefix=/usr          \
                --disable-docker-tests \
                --disable-static       &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install
}

run_all
