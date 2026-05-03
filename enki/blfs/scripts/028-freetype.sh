#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=freetype-2.14.1
SOURCE=freetype-2.14.1.tar.xz
URL=https://downloads.sourceforge.net/freetype/freetype-2.14.1.tar.xz
MD5=78c7d7450fb7d0999ccd029f84094340

run_build () {
    sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

    sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
        -i include/freetype/config/ftoption.h   &&

    ./configure --prefix=/usr            \
                --disable-static         \
                --enable-freetype-config \
                --with-harfbuzz=dynamic  &&
    make
}

run_test () {
    echo -n
}

run_install () {
    sudo make install
}

run_all
