#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=icu
SOURCE=icu4c-78.2-sources.tgz
URL=https://github.com/unicode-org/icu/releases/download/release-78.2/icu4c-78.2-sources.tgz
MD5=2bf8db43ccdc837e402ac773f17c7cf8

run_build () {
    case $(uname -m) in
      i?86) sed -e "s/U_PLATFORM_IS_LINUX_BASED/__X86_64__ \&\& &/" \
                -i source/test/intltest/ustrtest.cpp ;;
    esac

    cd source                 &&
    ./configure --prefix=/usr &&
    make
}

run_test () {
    make check
}

run_install () {
    sudo make install
}

run_all
