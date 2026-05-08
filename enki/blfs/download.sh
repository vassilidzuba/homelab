#/bin/bash
#
download() {
    if [ ! -f "sources/$SRC" ]; then
        echo "Downloading $URL"
        pushd sources
        wget -O "$SRC" "$URL"
        if [ "$MD5" != "" ]; then
            if [ "$(md5sum $SRC)" != "$MD5  $SRC" ]; then
                echo "BAD CHECKSUM : $SRC"
            fi
        fi
        popd
    fi
}

SRC=sudo-1.9.17p2.tar.gz
URL=https://www.sudo.ws/dist/sudo-1.9.17p2.tar.gz
MD5=dcbf46f739ae06b076e1a11cbb271a10
download

SRC=cmake-4.2.3.tar.gz
URL=https://cmake.org/files/v4.2/cmake-4.2.3.tar.gz
MD5=803a1720ec822a8660118a38ca51fc1b
download

SRC=nano-8.7.1.tar.xz
URL=https://www.nano-editor.org/dist/v8/nano-8.7.1.tar.xz
MD5=d873085c342e3670d108c08a0c3ebe2f
download

SRC=libidn2-2.3.8.tar.gz
URL=https://ftpmirror.gnu.org/libidn/libidn2-2.3.8.tar.gz
MD5=a8e113e040d57a523684e141970eea7a
download

SRC=libpsl-0.21.5.tar.gz
URL=https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz
MD5=70a798ee9860b6e77896548428dba7b
download

SRC=libtasn1-4.21.0.tar.gz
URL=https://ftpmirror.gnu.org/libtasn1/libtasn1-4.21.0.tar.gz
MD5=2ee1d9f3aa66f1e308c46a283aa9a8c2
download

SRC=p11-kit-0.26.2.tar.xz
URL=https://github.com/p11-glue/p11-kit/releases/download/0.26.2/p11-kit-0.26.2.tar.xz
MD5=99edde5f38697ed2d47c55544347be4e
download

SRC=nspr-4.38.2.tar.gz
URL=https://archive.mozilla.org/pub/nspr/releases/v4.38.2/src/nspr-4.38.2.tar.gz
MD5=c1b2e2b3f63774bbbec25af84567135b
download

SRC=nss-3.120.1.tar.gz
URL=https://archive.mozilla.org/pub/security/nss/releases/NSS_3_120_1_RTM/src/nss-3.120.1.tar.gz
MD5=c9642ff2241aa38c9e81589641652a50
download

SRC=nss-standalone-1.patch
URL=
MD5=
download

SRC=make-ca-1.16.1.tar.gz
URL=https://github.com/lfs-book/make-ca/archive/v1.16.1/make-ca-1.16.1.tar.gz
MD5=bf9cea2d24fc5344d4951b49f275c595
download

SRC=nettle-3.10.2.tar.gz
URL=https://ftpmirror.gnu.org/nettle/nettle-3.10.2.tar.gz
MD5=: b28bcbf6f045ff007940a9401673600d
download

SRC=gnutls-3.8.12.tar.xz
URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.12.tar.xz
MD5=df129bed331c18381991b5b8f36b7070
download

SRC=wget-1.25.0.tar.gz
URL=https://ftpmirror.gnu.org/wget/wget-1.25.0.tar.gz
MD5=c70ba58b36f944e8ba1d655ace552881
download

SRC=blfs-systemd-units-20251204.tar.xz
URL=https://www.linuxfromscratch.org/blfs/downloads/13.0-systemd/blfs-systemd-units-20251204.tar.xz
MD5=
download

SRC=libpng-1.6.54-apng.patch.gz
URL=https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.54-apng.patch.gz
MD5=073fb9cc80b7bad022bdfef53ddea540
download

SRC=llvm-cmake-21.1.8.src.tar.xz
URL=https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-cmake-21.1.8.src.tar.xz
MD5=fb75e927effbedba72de1f421154fd0c
download

SRC=llvm-third-party-21.1.8.src.tar.xz
URL=https://anduin.linuxfromscratch.org/BLFS/llvm/llvm-third-party-21.1.8.src.tar.xz
MD5=4cad220587e039a2ff9465766c018
download

SRC=clang-21.1.8.src.tar.xz
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-21.1.8.src.tar.xz
MD5=0e76ea8303e5a44d482773ad339c97d1
download

SRC=compiler-rt-21.1.8.src.tar.xz
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/compiler-rt-21.1.8.src.tar.xz
MD5=4659411fe5f4d78fc987ad7be6318b27
download

SRC=glib-skip_warnings-1.patch
URL=https://www.linuxfromscratch.org/patches/blfs/13.0/glib-skip_warnings-1.patch
MD5=
download

SRC=glib-2.86.4-upstream_fixes-1.patch
URL=https://www.linuxfromscratch.org/patches/blfs/13.0/glib-2.86.4-upstream_fixes-1.patch
MD5=
download

SRC=gobject-introspection-1.86.0.tar.xz
URL=https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz
MD5=fa0f2ae76868bf35ff725f940d75ec16
download
