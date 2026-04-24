#/bin/bash

echo '****' "Compiling binutils (pass 2)"

PACKAGE=binutils-2.46.0

if [ -f /mnt/lfs/usr/bin/as ]; then
  echo "Package $PACKAGE already built"
  exit 0
fi

cd $LFS/sources

if [ ! -d $PACKAGE ]; then
  tar xvJf $PACKAGE.tar.xz
fi

cd $PACKAGE

sed '6031s/$add_dir//' -i ltmain.sh

rm -rf build
mkdir -v build
cd       build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

make

make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd $LFS/sources
rm -rf $LFS/sources/$PACKAGE
