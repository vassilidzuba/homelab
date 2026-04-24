#/bin/bash

echo '****' "Building pcre2"

PACKAGE=pcre2-10.47
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi


cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvjf $PACKAGE.tar.bz2
fi

cd $PACKAGE

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.47 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
