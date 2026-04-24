#/bin/bash

echo '****' "Building gmp"

PACKAGE=gmp-6.3.0
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

sed -i '/long long t1;/,+1s/()/(...)/' configure

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0

make
make html

make check 2>&1 | tee /gmp-check.log

awk '/# PASS:/{total+=$3} ; END{print total}' /gmp-check.log

make install
make install-html

touch $FLAG
cd /sources
rm -rf $PACKAGE
