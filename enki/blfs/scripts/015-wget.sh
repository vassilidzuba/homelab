#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=wget-1.25.0
SOURCE=wget-1.25.0.tar.gz

run_build () {
    ./configure --prefix=/usr      \
                --sysconfdir=/etc  \
                --with-ssl=openssl &&
    make
}

run_test_ () {
    make check
}

run_install () {
    sudo make install
}

run_all
