#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=json-c-0.18
SOURCE=json-c-0.18.tar.gz
URL=https://s3.amazonaws.com/json-c_releases/releases/json-c-0.18.tar.gz
MD5=e6593766de7d8aa6e3a7e67ebf1e522f

run_build () {
    sed -i 's/VERSION 2.8/VERSION 4.0/' apps/CMakeLists.txt  &&
    sed -i 's/VERSION 3.9/VERSION 4.0/' tests/CMakeLists.txt

    mkdir build &&
    cd    build &&

    cmake -D CMAKE_INSTALL_PREFIX=/usr \
          -D CMAKE_BUILD_TYPE=Release  \
          -D BUILD_STATIC_LIBS=OFF     \
          .. &&
    make
}

run_test () {
    make test
}

run_install () {
    sudo make install
}

run_all
