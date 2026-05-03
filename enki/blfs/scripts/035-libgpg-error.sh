#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libgpg-error-1.59
SOURCE=libgpg-error-1.59.tar.bz2
URL=https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.59.tar.bz2
MD5=d8afb7b49472cadcc434fa65d6b527ef

run_build () {
    ./configure --prefix=/usr --sysconfdir=/etc &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install &&
    sudo install -v -m644 -D README /usr/share/doc/libgpg-error-1.59/README
}

run_all
