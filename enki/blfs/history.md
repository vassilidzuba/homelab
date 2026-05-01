# Enki installation - BLFS

This is based on  [https://www.linuxfromscratch.org/blfs/](BLFS book, version 13.0).

We will assume the LFS installation, is run under QUEMU.

## Sharing files

We want to be able to copy files from the host to the LFS installations. 
To do so, we will use [virtiofsd](https://wiki.archlinux.org/title/QEMU#Host_file_sharing_with_virtiofsd).

We first need to install virtiofsd:

    sudo pacman -S virtiofsd

We run the virtiofs daemon:

    sudo mkdir /tmp/vm-share
    sudo /usr/lib/virtiofsd --socket-path /tmp/vm-share.sock --socket-group kvm --shared-dir /tmp/vm-share

We ensure that /mnt/lfs is not mounted on the host

    sudo umount /mnt/lfs

We can then run the guest (LFS):

    sudo qemu-system-x86_64 \
        -kernel /boot/vmlinuz-6.18.10-lfs-13.0-systemd \
        -drive file=/dev/sda,format=raw \
        -append "root=/dev/sda3 console=ttyS0" \
        -nographic \
        -m 4G \
        -object memory-backend-memfd,id=mem,size=4G,share=on \
        -numa node,memdev=mem \
        -chardev socket,id=char0,path=/tmp/vm-share.sock \
        -cpu host \
        -enable-kvm \mkdir .lfsflags  
        -device vhost-user-fs-pci,chardev=char0,tag=myfs

on the host, we give the access right to our normal user:

    chown xxx:yyy /tmp/vm-share

In the guest, one mount the shared directory:

    mount -t virtiofs myfs /mnt/vm-share

## Running scripts

The scripts are in the directory `./scripts`. To use them one need to:

* on the host, copy then to the shared volume using `./copy-to-share.sh`
* on the guest, run them as `/mnt/vm-share/...` 
* on the guest export the variable `SHAREDDIR` with the value `/mnt/vm-share`

The build scripts use files in `/lfsflags/blfs` to avoid repeating 
the build, so we need to create that directory.

## Downloading packages

As the guest (LFS) isn't able to dowload packages yet, we download them 
on the host with the script [download.sh]()./download.sh).

## Add an user

One can add an user by running the script [001-create-user.sh](./scripts/001-create-user.sh)

## Build *sudo*

To be able to effectively use the new user, one need to build `sudo`.

The build script is [002-sudo.sh](./scripts/002-sudo.sh).

One needs to add the user to the group `wheel`:

    usermod -a -G wheel username

where *username* si replacved by the actual user name.

After checking that sudo actually works, one can disable
the root password:

     sudo passwd -d root
     sudo passwd --lock root

## Build some other packages

As it's fun to have *fastfetch* (in extra), we fist need to build
some packages befotre being able to build *fastfetch*:

* [scripts/003-cmake.sh](003-cmake.sh)

We need an editor (for those that don't like `vim`):

* [scripts/004-nano.sh](004-nano.sh)

We need program to download files from the internet:

* [scripts/005-libunistring.sh](005-libunistring.sh)
* [scripts/006-libidn2.sh](006-libidn2.sh)
* [scripts/007-libpsl.sh](007-libpsl.sh)
* [scripts/008-libtasn1.sh](008-libtasn1.sh)
* [scripts/009-p11-kit.sh](009-p11-kit.sh)
* [scripts/010-nspr.sh](010-nspr.sh)
* [scripts/011-nss.sh](nss.sh)
* [scripts/012-make-ca.sh](make-ca.sh)
* [scripts/013-nettle.sh](nettle.sh)
* [scripts/014-gnutls.sh](gnutls.sh)
* [scripts/015-wget.sh](wget.sh)
* [scripts/016-curl.sh](curl.sh)

note: many wget tests failed, for unknown reason. The program seems to work however.
