#/bin/bash

echo '****' "Building procps-ng"

PACKAGE=procps-ng-4.0.6
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

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.6 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit                      \
            --with-systemd

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install

touch $FLAG
cd /sources
rm -rf $PACKAGE
