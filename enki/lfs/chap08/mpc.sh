#/bin/bash

echo '****' "Building mpc"

PACKAGE=mpc-1.3.1
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi


cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvzf $PACKAGE.tar.gz
fi

cd $PACKAGE

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1

make
make html

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi


make install
make install-html

touch $FLAG
cd /sources
rm -rf $PACKAGE
