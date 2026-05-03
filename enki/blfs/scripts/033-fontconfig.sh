#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=fontconfig-2.17.1
SOURCE=fontconfig-2.17.1.tar.xz
URL=https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/2.17.1/fontconfig-2.17.1.tar.xz
MD5=f68f95052c7297b98eccb7709d817f6a

run_build () {
    ./configure --prefix=/usr        \
                --sysconfdir=/etc    \
                --localstatedir=/var \
                --disable-docs       \
                --docdir=/usr/share/doc/fontconfig-2.17.1 &&
    make
}

run_test () {
    make check

    echo -n
}

run_install () {
    sudo make install
}

run_all
