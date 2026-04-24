#/bin/bash

echo '****' "Building texinfo"

PACKAGE=texinfo-7.2
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

sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm

./configure --prefix=/usr

make

make check

make install

make TEXMF=/usr/share/texmf install-tex

touch $FLAG
cd /sources
rm -rf $PACKAGE
