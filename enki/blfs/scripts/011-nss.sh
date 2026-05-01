#!/bin/bash


if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
    exit 255
fi

PACKAGE=nss-3.120.1
FLAG=/lfsflags/blfs/$PACKAGE
SOURCE=nss-3.120.1.tar.gz
PATCH=nss-standalone-1.patch

if [ -f "$FLAG" ]; then
    echo "Package $PACKAGE is already built."
    exit 255
fi

if [ ! -f "/sources/$SOURCE" ]; then
    cp "$SHAREDDIR/$SOURCE" /sources
fi

cp "$SHAREDDIR/$PATCH" /sources

cd /sources

if [ ! -d $PACKAGE ]; then
  tar xvf $SOURCE
  if [ $? -eq 1 ]; then
      echo "unable to extract archive"
      exit 255
  fi
fi

cd $PACKAGE

patch -Np1 -i ../nss-standalone-1.patch &&

cd nss &&

make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  NSS_USE_SYSTEM_SQLITE=1             \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1)

if [ "$?" != 0 ]; then
    echo "Build of $PACKAGE failed"
    exit 255
fi

cd tests &&
HOST=localhost DOMSUF=localdomain ./all.sh
cd ../

if [ "$?" != 0 ]; then
    echo "Tests of $PACKAGE failed"
    exit 255
fi

cd ../dist                                                          &&

sudo install -v -m755 Linux*/lib/*.so              /usr/lib              &&
sudo install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib              &&

sudo install -v -m755 -d                           /usr/include/nss      &&
sudo cp -v -RL {public,private}/nss/*              /usr/include/nss      &&

sudo install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&

sudo install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig &&

sudo ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

if [ "$?" != 0 ]; then
    echo "Install of $PACKAGE failed"
    exit 255
fi

touch $FLAG
cd /sources
rm -rf $PACKAGE
