#/bin/bash

echo '****' "Building kmod"

PACKAGE=kmod-34.2
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

mkdir -p build
cd       build

meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false

ninja

ninja install

touch $FLAG
cd /sources
rm -rf $PACKAGE
