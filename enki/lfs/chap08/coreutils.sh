#/bin/bash

echo '****' "Building coreutils"

PACKAGE=coreutils-9.10
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

patch -Np1 -i ../coreutils-9.10-i18n-1.patch

autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr


make

make NON_ROOT_USERNAME=tester check-root

groupadd -g 102 dummy -U tester

chown -R tester .

su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
   < /dev/null

groupdel dummy

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

touch $FLAG
cd /sources
rm -rf $PACKAGE
