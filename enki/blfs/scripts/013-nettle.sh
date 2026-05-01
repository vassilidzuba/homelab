#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=nettle-3.10.2
SOURCE=nettle-3.10.2.tar.gz

run_build () {
    ./configure --prefix=/usr --disable-static &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install &&
    sudo chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
    sudo install -v -m755 -d /usr/share/doc/nettle-3.10.2 &&
    sudo install -v -m644 nettle.{html,pdf} /usr/share/doc/nettle-3.10.2
}

run_all
