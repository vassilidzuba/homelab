#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=make-ca-1.16.1
SOURCE=make-ca-1.16.1.tar.gz

run_build () {
    sed '/mktemp/s/-t //' -i make-ca
}

run_install () {
    sudo make install &&
    sudo install -vdm755 /etc/ssl/local &&
    sudo /usr/sbin/make-ca -g
}

run_all
