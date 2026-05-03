#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=libgcrypt-1.12.0
SOURCE=libgcrypt-1.12.0.tar.bz2
URL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.12.0.tar.bz2
MD5=f43a87fa7d779fbfb7a0985567521850

run_build () {
    ./configure --prefix=/usr &&
    make                      &&

    make -C doc html                                                       &&
    makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
    makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi
}

run_test () {
    make check
}

run_install () {
    sudo make install &&
    sudo install -v -dm755   /usr/share/doc/libgcrypt-1.12.0 &&
    sudo install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                        /usr/share/doc/libgcrypt-1.12.0 &&

    sudo install -v -dm755   /usr/share/doc/libgcrypt-1.12.0/html &&
    sudo install -v -m644 doc/gcrypt.html/* \
                        /usr/share/doc/libgcrypt-1.12.0/html &&
    sudo install -v -m644 doc/gcrypt_nochunks.html \
                        /usr/share/doc/libgcrypt-1.12.0      &&
    sudo install -v -m644 doc/gcrypt.{txt,texi} \
                        /usr/share/doc/libgcrypt-1.12.0
}

run_all
