#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=openssh-10.2p1
SOURCE=openssh-10.2p1.tar.gz
URL=https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz
MD5=801b5ad6da38e0045de20dd5dd2f6a80

run_build () {
    if [ ! -d /var/lib/sshd ]; then
        sudo install -v -g sys -m700 -d /var/lib/sshd &&

        sudo groupadd -g 50 sshd        &&
        sudo useradd  -c 'sshd PrivSep' \
                 -d /var/lib/sshd  \
                 -g sshd           \
                 -s /bin/false     \
                 -u 50 sshd
    fi

    ./configure --prefix=/usr                            \
                --sysconfdir=/etc/ssh                    \
                --with-privsep-path=/var/lib/sshd        \
                --with-default-path=/usr/bin             \
                --with-superuser-path=/usr/sbin:/usr/bin \
                --with-pid-dir=/run                      &&
    make
}

run_test () {
    make -j1 tests
}

run_install () {
    sudo make install &&
    sudo install -v -m755    contrib/ssh-copy-id /usr/bin     &&

    sudo install -v -m644    contrib/ssh-copy-id.1 \
                        /usr/share/man/man1              &&
    sudo install -v -m755 -d /usr/share/doc/openssh-10.2p1     &&
    sudo install -v -m644    INSTALL LICENCE OVERVIEW README* \
                        /usr/share/doc/openssh-10.2p1
}

run_all
