#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=which-2.23
SOURCE=which-2.23.tar.gz
URL=https://ftpmirror.gnu.org/which/which-2.23.tar.gz
MD5=1963b85914132d78373f02a84cdb3c86

run_build () {
    ./configure --prefix=/usr &&
    make
}

run_test () {
    echo -n
}

run_install () {
    sudo make install
}

run_all
