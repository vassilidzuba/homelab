#/bin/bash

echo '****' "Building tar"

PACKAGE=tar-1.35
FLAG=/lfsflags/chap08/$PACKAGE

if [ -f $FLAG ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
  if [ $? -ne 0 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

make

make check

make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

touch $FLAG
cd /sources
rm -rf $PACKAGE
