#/bin/bash

echo '****' "Building mpfr"

PACKAGE=mpfr-4.2.2
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi


cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2

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
