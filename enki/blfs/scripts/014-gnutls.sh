#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=gnutls-3.8.12
SOURCE=gnutls-3.8.12.tar.xz

run_build () {
    ./configure --prefix=/usr \
                --docdir=/usr/share/doc/gnutls-3.8.12 \
                --with-default-trust-store-pkcs11="pkcs11:" &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install
}

run_all
