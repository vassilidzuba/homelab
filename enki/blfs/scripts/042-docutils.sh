#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
source $SCRIPT_DIR/_utilities.sh

PACKAGE=docutils-0.22.4
SOURCE=docutils-0.22.4.tar.gz
URL=https://files.pythonhosted.org/packages/source/d/docutils/docutils-0.22.4.tar.gz
MD5=58f718cd60a87725d4dac56ae427c9f8

run_build () {
    for f in /usr/bin/rst*.py; do
      sudo rm -fv /usr/bin/$(basename $f .py)
    done

    pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
}

run_test () {
    echo -n
}

run_install () {
    sudo pip3 install --no-index --find-links dist --no-user docutils
}

run_all
