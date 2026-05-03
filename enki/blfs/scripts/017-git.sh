#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=git-2.53.0
SOURCE=git-2.53.0.tar.xz
URL=https://www.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz
MD5=3857733169a6443e48d20c75ee32f732

run_build () {
    ./configure --prefix=/usr                   \
                --with-gitconfig=/etc/gitconfig \
                --with-python=python3           \
                --with-libpcre2                 &&
    make
}

run_test () {
    GIT_UNZIP=nonexist make test -k
}

run_install () {
    sudo make perllibdir=/usr/lib/perl5/5.42/site_perl install
}

run_all
