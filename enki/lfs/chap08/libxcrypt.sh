#/bin/bash

echo '****' "Building libxcrypt"

PACKAGE=libxcrypt-4.5.2
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

sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi


make install

touch $FLAGcd /sources
rm -rf $PACKAGE
