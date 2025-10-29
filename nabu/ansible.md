# Ansible

We describe here the use of ansible in several contexts:

- installation of virtual servers adad[1, 2, 3], as an exercice

## ADAD

The three servers `adad*` are three virtual servers running on guest `nabu`.
Ansible will be run froim within nabu, with the configuration in
`~/ansible/adad`.

### Installation

There will be three servers, all installed from `debian-13.1.0-amd64-DVD-1.iso`. They will be manually installed
using `virt-manager`.

### Manual configuration

- create virtual machines (4 Gb of memory, 20 Gb of disk, 2 cpu, ssh server), user *vassili*, root enabled
- run the VMs
- distribute the ssh keys

Note: in the initial state of our VMs, the root password is enabled and `sudo` is not installed. We will install sudo using ansible,
but for that we will need to use the root account. To be able to connect with ssh to the root account, one needs to modify 
on the guest the `sshd_config` file by adding:

    PermitRootLogin yes

and restart the service:

    systemctl restart sshd

Of course, this is not a good practice. With real servers, one should start with no root password and sudo installed.

The commands to distribute the keys, to be run on `nabu` are:

    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@adad1
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@adad2
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@adad3

    ssh-copy-id -i ~/.ssh/id_ed25519  root@adad1
    ssh-copy-id -i ~/.ssh/id_ed25519  root@adad2
    ssh-copy-id -i ~/.ssh/id_ed25519  root@adad3

After installing the keys, one will take a snapshot of all our VM, to be able to restart running ansible from 
the initial state if one wishes so.

To start or shutdown a VM with virsh:

    sudo virsh start adad1
    sudo virsh shutdown adad1

To get the status:

   sudo virsh domstate adad1

### Testing

To perform that test, or running ansible in general, one needs to run the ssh agent if it doesn't run yet:

    eval "$(ssh-agent)"
    ssh-add ~/.ssh/id_ed25519

To test that ansible works:

    ansible -u vassili -i "adad1,adad2,adad3" all -m ping
    ansible -u root -i "adad1,adad2,adad3" all -m ping

Nothe that if we don't use the option `-u`, ansible uses the current user.

### Inventory

The inventory file is [00-inventory.yml](ansible/adad/00-inventory.yml) It will contain:

    ---
    all:
      children:
        vbox:
          hosts:
            adad1:
            adad2:
            adad1:

By default, ansible will try to discover the python interpreter on the target machines, and display a nessage indicating
what it has found. We can avoid this message by creating a file `group_vars/all/variables.yml` the contains

    ansible_python_interpreter: "/usr/bin/python"

We can specify the default inventory in the ansible configuration file. As we will havve several contexts, we define
a file `ansible.cfg` in the current directory that will contain:

    [defaults]
    inventory = ~/ansible/adad/àà-inventory.yml


### Executing a command

We can execute a command on all the target VM by using something like

    ansible all -m command -a uptime

and on a single one:

    ansible adad1 -m command -a uptime

## Installing sudo

We first will install sudo on the VMs, using a playbook [01-install-sudo.yml](ansible/adad/01-install-sudo.yml):

Note that the initial installation has no source list defined but for the cdrom. One need to copy the source 
list using the playbook, and remove the cdrom from the source list.

The playbook will:

- copy data/sources/list to /etc/apt/sources.list
- copy data/debian.source to /etc/apt/sources.list.d/
- copy data/debian-security.source to /etc/apt/sources.list.d/
- install the package sudo
- add user `vassili` to the `sudo` group

The playbook is [01-install-sudo.yml](ansible/adad/01-install-sudo.yml).

The two source files are [debian.sources](ansible/adad/debian.sources) 
and [debian-security.sources](ansible/adad/debian-security.sources)

To run the playbook, the command is:

    ansible-playbook 01-install-sudo.yml

## Installing Nginx

We will install Nginx with a simple static site (a single index file for the time being) on `adad1`.

The playbook will be [02-install-nginx.yml](ansible/adad/02-install-nginx.yml).

It needs to be run with the `--ask-become-pass` option:

    ansible-playbook 02-install-nginx.yml --ask-become-pass

The steps of the playbook are /

- install nginx package
- remove the obsolete data and copy the new data
- copy the CA certificate and execute `update-ca-certificates`
- copy the webserver certificate
- copy the server config and restart nginx

### Copying data

The playbook copies data from `data/javadoc/html` to `var/www/html`.
The directory `data/javadoc` contains a script `build-index.sh` that build the HTML index file
from the javadoc jar files present in subdirectory `javadoc`.

### Certificate 

To be able to use SSL, we need a certificate. The certificate creation process is described 
in the description of the Odin server: [Certificates.md](../odin/Certificates.md).
We will use the same CA that in that case.
