#/bin/bash

echo '****' "Building expect"

PACKAGE=expect5.45.4
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

python3 -c 'from pty import spawn; spawn(["echo", "ok"])'

patch -Np1 -i ../expect-5.45.4-gcc15-1.patch

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make

make test

if [ $? -eq 1 ]; then
    echo "check failed"
    exit 255
fi

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

touch $FLAGcd /sources
rm -rf $PACKAGE
