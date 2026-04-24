#/bin/bash

echo '****' "Building flex"

PACKAGE=flex-2.6.4
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
            --docdir=/usr/share/doc/flex-2.6.4

make

make check

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make install

ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

touch $FLAGcd /sources
rm -rf $PACKAGE
