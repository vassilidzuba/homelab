# Enki installation - LFS

This installation is based on version 13 of the LFS book.


# Preparation

- the host system is Arch.
- the script `version_check.sh` has been extracted from the book and copied here. It runs successfully.
- The installation partition is `/dev/sda3`.
- The swap partition is `/dev/sda2`
- the file `setup.sh` defines the environment variable. It sould be executed using `source ./setup.sh`.
- the umask in the host is already correct (`022`)
- create mount point `/mnt/lfs` and add it in `/etc/fstab`

## Packages

The packages are dowloaded into $LFS/sources as indicated in the book.

    wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

and the md5 sum verified

    md5sum -c md5sum
    
The last stable kernel has been downloaded (`6.19.11`)

## Final preparation.

As indicated in the book.

The script `create_directory_layout.sh` creates the limited directory layour 

We now must create a `lfs` use as specified in the book, section 4.3,
and execute script `update_owners.sh`.

The section 4.4 of the book describes how to set up the envisonment for 
the user `lfs` (files `.bashrc` and `.bash_profile`).

# Compiling a cross-toolchain

This is described in chapter 5 of the book.

To perform the build, execute

    chap05.sh

while logged as user `lfs`.

# Cross-compiling temporary tools

This is described in chapter 6 of the book.

To perform the build, execute

    chap06.sh

while logged as user `lfs`.

# Entering Chroot and Building Additional Temporary Tools

This is described in chapter 7 of the book.

First, we reset the ownership of the directories in $LFS to root
(section 7.2 of the book) by running the script `reset_owner.sh` as root.

    sudo ./chap07/prepare_vhs.sh

To make the scrips availble in the chrooted environment:

    sudo ./copy_to_chroot.sh

To enter the chroot/

    sudo su
    source ./chap07/enter_chroot.sh

When in the chroot:

    /lnfscripts/create_directories/.sh
    /lnfscripts/create_files.sh

and next we build some tools:

    /lnfscripts/gettext.sh
    /lnfscripts/bison.sh
    /lnfscripts/perl.sh
    /lnfscripts/python.sh
    /lnfscripts/texinfo.sh
    /lnfscripts/util_linux.sh

We finally clean the system/

    /lfsscripts/cleanu.sh

From the host system, one now unmount the VFS:

   sudo ./chap07/umount_vfs.sh
   
and one performs the backup of the LFS partition/

   sudo ./chap07/backup.sh

#  Installing Basic System Software 

This is described in chapter 8 of the book.
These scripts will be run in chroot, with the kernel virtual file systems set.

When in chroot:

    /lfsscripts/man-pages.sh
    /lfsscripts/iana-etc.sh
    /lfsscripts/glibc.sh
    /lfsscripts/zlib.sh
    /lfsscripts/bzip1.sh
    /lfsscripts/xz.sh
    /lfsscripts/lz4.sh
    /lfsscripts/zstd.sh
    /lfsscripts/file.sh
    /lfsscripts/readline.sh
    /lfsscripts/pcre2.sh
    /lfsscripts/m4.sh
    /lfsscripts/bc.sh
    /lfsscripts/flex.sh
    /lfsscripts/tcl.sh
    /lfsscripts/expect.sh
    /lfsscripts/dejagnu.sh
    /lfsscripts/pkgconf.sh
    /lfsscripts/binutils.sh
    /lfsscripts/gmp.sh
    /lfsscripts/mpfr.sh
    /lfsscripts/mpc.sh
    /lfsscripts/attr.sh
    /lfsscripts/acl.sh
    /lfsscripts/libcap.sh
    /lfsscripts/libxcrypt.sh
    /lfsscripts/shadow.sh
    /lfsscripts/gcc.sh
    /lfsscripts/ncurses.sh
    /lfsscripts/sed.sh
    /lfsscripts/psmisc.sh
    /lfsscripts/gettext.sh
    /lfsscripts/bison.sh
    /lfsscripts/grep.sh
    /lfsscripts/bash.sh
    /lfsscripts/libtool.sh
    /lfsscripts/gdbm.sh
    /lfsscripts/gperf.sh
    /lfsscripts/expat.sh
    /lfsscripts/inetutils.sh
    /lfsscripts/less.sh
    /lfsscripts/perl.sh
    /lfsscripts/xml-parser.sh
    /lfsscripts/intltool.sh
    /lfsscripts/autoconf.sh
    /lfsscripts/automake.sh
    /lfsscripts/openssl.sh
    /lfsscripts/libelf.sh
    /lfsscripts/libffi.sh
    /lfsscripts/sqlite.sh
    /lfsscripts/python.sh
    /lfsscripts/flit-core.sh
    /lfsscripts/wheel.sh
    /lfsscripts/setuptools.sh
    /lfsscripts/ninja.sh
    /lfsscripts/meson.sh
    /lfsscripts/kmod.sh
    /lfsscripts/coreutils.sh
    /lfsscripts/diffutils.sh
    /lfsscripts/gawk.sh
    /lfsscripts/findutils.sh
    /lfsscripts/groff.sh
    /lfsscripts/grub.sh
    /lfsscripts/gzip.sh
    /lfsscripts/iproute2.sh
    /lfsscripts/kbd.sh
    /lfsscripts/libpipeline.sh
    /lfsscripts/make.sh
    /lfsscripts/patch.sh
    /lfsscripts/tar.sh
    /lfsscripts/texinfo.sh
    /lfsscripts/vim.sh
    /lfsscripts/markupsafe.sh
    /lfsscripts/jinja2.sh
    /lfsscripts/systemd.sh
    /lfsscripts/dbus.sh
    /lfsscripts/man-db.sh
    /lfsscripts/procps.sh
    /lfsscripts/util-linux.sh
    /lfsscripts/e2fsprogs.sh

to strip debuging symbols:

    /lfsscripts/stripping.sh

to perform a final cleanup (warning, that will remove the user `tester`):

    /lfsscripts/cleanup.sh
