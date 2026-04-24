#/bin/bash

echo '****' "Building dbus"

PACKAGE=dbus-1.16.2
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

mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..

ninja

ninja test

ninja install

ln -sfv /etc/machine-id /var/lib/dbus

touch $FLAG
cd /sources
rm -rf $PACKAGE
