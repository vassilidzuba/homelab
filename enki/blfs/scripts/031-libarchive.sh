#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libarchive-3.8.5
SOURCE=libarchive-3.8.5.tar.xz
URL=https://github.com/libarchive/libarchive/releases/download/v3.8.5/libarchive-3.8.5.tar.xz
MD5=2cd5a73ed7fe7f9da22d34ac1048534e

run_build () {
    ./configure --prefix=/usr --disable-static &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install &&
    sudo ln -sfv bsdunzip /usr/bin/unzip
}

run_all
