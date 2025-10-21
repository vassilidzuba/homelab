# NABU - history

This document describes the installation of node *nabu*.

It is aimed at becoming my main driver, using Arch.

## Context

Arch will be installed in /dev/sda4. There is already a distro in /dev/sda3. The UEFI partition is /dev/sda1. The swap partition is /dev/sda2.

## Download the media

Download the media from archlinux site.

If on windows, check the sha256 key using:

    certutil -hashfile  archlinux-2025.10.01-x86_64.iso  SHA256

A bootable usb key can be created using *rufus*.

## Base install

(2025-10-01)

The installation manual is at [https://wiki.archlinux.org/title/Installation_guide](https://wiki.archlinux.org/title/Installation_guide). 
What follows is not intended to replace the installation manual, only indicate the essential commands I used during this installation.

I need to select the keyboard map

    loadkeys fr-latin1

ensure clock is synchronized:

    timedatectl

the disk is already partitioned, we only need to format and mount the root partition and enable the swap:

    mkfs.ext4 /dev/sda4
    mount /dev/sda4 /mnt
    mount --mkdir /dev/sda1 /mnt/boot
    swapon /dev/sda2
   
To install the base packages, we use the command:

    pacstrap -K /mnt base linux linux-firmware amd-ucode

warning: amd-ucode is installed in the boot partition, and must be installed only once

To create the fstab:

    genfstab -U /mnt >> /mnt/etc/fstab

To enter the chroot:

    arch-chroot /mnt

Set the timezone:

    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
    hwclock --systohc

install nano

    pacman -S nano


edit /etc/locale.gen to enable the locales one want, and run:

    locale-gen
    echo LANG=fr_FR.UTF-8 > /etc/locale.conf
    echo KEYMAP=fr-latin1 > /etc/vconsole.conf

install additional packages:

    pacman -S dhcpcd lynx

Do not forget to enable the network:

    echo nabu > /etc/hostname
    systemctl enable systemd-networkd
    systemctl enable dhcpcd

Set the root password:

    passwd

### install boot manager

install required packages:

    pacman -S grub efibootmgr

install grub

    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
    grub-mkconfig -o /boot/grub/grub.cfg

In my case, I have another distribution that i want to add to the grub menu.

    pacman -S os-prober
    mount --mkdir /dev/sda3 /mnt/olddistro

uncomment GRUB_DISABLE_OS_PROBER=false in /etc/default/grub, and run grub-mkconfig again.


We can now reboot in the new install

## Security

We create a new user (here *myuser* as an example):

    useradd -m -G users,wheel myuser
    passwd myuser

Allow sudo:

    pacman -S sudo

and uncomment *%wheel ALL (ALL:lALL) ALL* in /etc/sudoers

We can now disable the root password:

    sudo passwd -d root
    sudo passwd --lock root


## Other partitions

We can add other partitions to the fstab. To do that in the installed system, one would install the installation scripts:

    sudo pacman -S arch-install-scripts

then we can mount manually the partitions we are interested in, and generate a fake fstab with

    genfstab / -U > ~/fstab

and finally copy the entries we are interested in to the actual `/etc/fstab`.

It is also possible to add them manually. To obtain the list of existing partitions, one uses:

    lsblk -f

To add a linux partition, one adds for instance the following line to `/etc/fstab`:

    UUID=c8267a4b-e8dc-4291-b565-aac0e5147e2b /mnt/olddistro ext4   rw,noatime 0 0

To add a ntfs partition, one uses for instance the following line:

    UUID=04100F34100F2C6C    /mnt/win    ntfs    defaults,uid=1000,gid=1000    0 0

To mount the newly declared partitions:

    sudo systemctl daemon-reload
    sudo mount -a


## Utilities

### Smartctl

To use smartctl, one need to install a package

    sudo pacman -S smartmontools

One can obtain the list of devices by

    sudo smartctl --scan

and all the info about a given device (here /dev/sda) by 

    sudo smartctl --all /dev/sda

## Weyland and Hyprland

Packages:

* nvidia driver: nvidia-open
* righs management: polkit
* terminal: kitty
* browser: firefox (with pipewire-jack)
* compositor: hyprland

To launch, `hyprland`

The documentation of the configuration of hyprland is in [hyprland.md](hyprland.md).


## ssh

We install the ssh client.

    sudo pacman -S openssh

We'll test it with a machine names 'odin'. As we don't have a dns (yet), we add odin to the ssh config file ~/.ssh/config :

    Host odin
        Hostname 192.168.0.20
        Port 22
        User vassili

So now we can connect using simply:

    ssh odin

Now we generate a key pair:

    ssh-keygen -t ed25519 -C 'nabu'

with the default file name `~/.ssh/id_ed25519` and a passphrase

we now copy the public key to odin:

    ssh-copy-id -i ~/.ssh/id_ed25519 odin

we can launch and use the ssh agent

    eval "$(ssh-agent)"
    ssh-add ~/.ssh/id_ed25519

## Git

We install git:

    sudo pacman -S git

We set the global properties

    git config --global user.email "myself@provider.com"
    git config --global user.name "Vassili Dzuba"

We create a ssh key pair for github:

    ssh-keygen -t ed25519 -C "github"

with the filename `.ssh/github_id_ed25519` and a passphrase

We now copy the public key to github using a browser.

We need to add the github ssh key to the ssh agent:

    eval "$(ssh-agent)"
    ssh-add ~/.ssh/github_id_ed25519

and now we can clone the repository:
  
    git clone git@github.com:vassilidzuba/homelab.git

and, after copying the files :

     git add <the files to be added>
     git commit -m "initial"
     pit push -u origin main
     

## Use DNS on odin

The `/etc/resolv.conf` id recreated at each boot by *dhcpcd*. We have now the DNS server on Odin
which is not known from the freebox. So we need to modify the file `/etc/dhcpcd.conf` to add

    nohook resolv.conf

And of course in resolv.conf , we replace *192.168.0.254* by *192.168.0.20* and add

    search manul.lan

where *manul.lan* is the name of the local network.

## Access to CIFS shares

One first need to install the package `smbclient`.

To list the shares, one can use:

    smbclient -L odin.manul.lan -U%

In what folows, we will access the sahe *red1*.

There are several ways to mount the Samba shares. We will use *systemd* for that.

For each share, we define a .mount file in /etc/systemd/system. The name of the file must correspond to the 
mount point. For instance, *mnt-red1.mount* corresponds to */mnt/red1*.

Here is the *.mount* file for the CIFS share: [mnt-red1.mount](scripts/mnt-red1.mount).

One also need to create a credential file. This file will be stored in the directory `/etc/Sambe/credentials` and 
will have as name the name of the mount point, for instance:

    /etc/samba/credentials/red1

It will contain the username and password of the share:

    username=vassili
    password=mysecretpassword

Note that:

* `/etc/samba/credentials` should have mod 700
* `/etc/samba/credentials/red1` should have mod 600

To launch the service for that share, we need to run:

    sudo systemctl daemon-reload
    sudo systemctl start mnt-red1.mount
    sudo systemctl enable mnt-red1.mount


# Tools

Here are various tools that one can install.

## Editors and IDE

* emacs (package `emacs-weyland`)

## File managers

* thunar (packages `thunar` and `thunar-archive-plugin`)

## Miscellaneous

* tree (packge `tree`)
* fastfetch (package `fastfetch`)

