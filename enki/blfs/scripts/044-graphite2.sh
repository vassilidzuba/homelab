#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=graphite2-1.3.14
SOURCE=graphite2-1.3.14.tgz
URL=https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz
MD5=1bccb985a7da01092bfb53bb5041e836

run_build () {
    sed -i '/cmptest/d' tests/CMakeLists.txt

    sed -i '/cmake_policy(SET CMP0012 NEW)/d' CMakeLists.txt &&
    sed -i 's/PythonInterp/Python3/' CMakeLists.txt          &&
    find . -name CMakeLists.txt | xargs sed -i 's/VERSION 2.8.0 FATAL_ERROR/VERSION 4.0.0/'

    sed -i '/Font.h/i #include <cstdint>' tests/featuremap/featuremaptest.cpp

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr .. &&
    make
}

run_test () {
    make test
}

run_install () {
    sudo make install
}

run_all
