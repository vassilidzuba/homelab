#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=nasm-3.01
SOURCE=nasm-3.01.tar.xz
URL=https://www.nasm.us/pub/nasm/releasebuilds/3.01/nasm-3.01.tar.xz
MD5=8414016d6ad0e113958c29066dfcc550

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
