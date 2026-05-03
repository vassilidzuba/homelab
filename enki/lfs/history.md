cd git  # Enki installation - LFS

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

# System configuration

The configurations are stored in `chap09` in the repo, and copied to 
the LFS environment by the script `copy_to_chroot_9.sh`, that must be run as `root`.

We use `/etc/resolv.conf`, so we need to disable systemd-resolved:

    systemctl disable systemd-resolved

We need to define some locale:

  localedef -i C -f UTF-8 C.UTF-8
  localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
  localedef -i en_US -f UTF-8 en_US.UTF-8

We will also copy fstab (that will need to be changed on another computer)
while it belongs to chapter 10 of the book.

As i'm using kitty in the host computer, we will also need to copy the terminfo
file `xterm-kitty` to the LFS envioronment.

# Making the LFS system bootable

## Building of the kernel

We will use the LTS kernel version `7.0.3`, while the book uses version `6.18.10`.

We may need to add some config options to the defauilt config:

- FUSE and VIRTIO_FS to be able to share a directory when running under quemu
- USER_NS to compile some packages
- maybe some network driver if missing in the default config (IGB in my case)

That will be done in `make menuconfig`.

The commands are, while in the kernel source directory,

    make mrproper
    make defconfig
    make menuconfig
    make
    make modules_install
    
    cp -r Documentation -T /usr/share/doc/linux-6.18.10
    chown -R 0:0 .
    
    install -v -m755 -d /etc/modprobe.d
    cat > /etc/modprobe.d/usb.conf << "EOF"
    # Begin /etc/modprobe.d/usb.conf
    
    install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
    install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
    
    # End /etc/modprobe.d/usb.conf
    EOF

## Setup the boot process

In my case, I simply add the new installation to the existing grub.

First we copy the kernel to the boot partition (from the host):


    #if not already mounted
    mount /boot 
    
    cd /mnt/lfs/sources/linux-6.18.10
    cp -iv  arch/x86/boot/bzImage /boot/vmlinuz-6.18.10-lfs-13.0-systemd
    cp -iv System.map /boot/System.map-6.18.10
    cp -iv .config /boot/config-6.18.10
   
We add a menuentry in `/etc/grub.d.40_custom`:

    menuentry "LFS, Linux 6.18.10-lfs-13.0-systemd" {
        load_video
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod ext2
        insmod fat
        set root=(hd0,1)
        echo 'Chargement de Linux From Scratch...'
        linux   /vmlinuz-6.18.10-lfs-13.0-systemd root=/dev/sda3 rw debug
    }

We finally make the grub config:

    grub_config -o /boot/grub/grub.cfg

# The end

We can now follow the book section 11.1, and reboot to our new LFS installation.


# QUEMU

To build BLFS, it would be easier to run both Arch and LFS simultaneously, while LFS runs in a virtual machine.

For that, we must avoid mounting the same volume in both Arch and LFS,
so we need in LFS to modify /etc/fstab to mount only the LFS partition (`/dev/sd3` here).

For that, one can, from the host:

* unmount /mnt/lfs
* run LFS under QEMU

To do so, enter the following command:

    sudo qemu-system-x86_64 -kernel /boot/vmlinuz-6.18.10-lfs-13.0-systemd  -drive file=/dev/sda,format=raw -append "root=/dev/sda3 console=ttyS0"-nographic

This commands requires `sudo` to have access to `/dev/sda`.

If a read-only access is sufficient (which is recommended by QEMU documentation, but not very usefull for out aim), add parameter `-snapshot`.

To quit the virtual machine, perform a shutdown or log off and type `Ctrl-a x`

# New kernels

To create the trust gpg database:

    gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org

To install a new kernel (we will assume version 7.0.3):

We will do the following on the host

* download the archive from [https://kernel.org/](hernel.org).
* download the pgp signature
* uncompress the kernel archive: `unxz linux-...`
* check the key: `pgp2 --verify linux-...sign linux-...tar`
* copy the kernel archive to the LFS installation in `\sources`

when in LFS:

* extract the archive
* cd into the directory
* execute `make mrproper`
* copy the last .config to the current directory

After that, we execute:

    make oldconfig
    make
    sudo make modules_install
    sudo cp -r Documentation -T /usr/share/doc/linux-7.0.3
    sudo chown -R 0:0 .
    
    sudo cp -iv  arch/x86/boot/bzImage /boot/vmlinuz-7.0.3-lfs-13.0-systemd
    sudo cp -iv System.map /boot/System.map-7.0.3
    sudo cp -iv .config /boot/config-7.0.3

and we continue setting up the boot process as previously described.
