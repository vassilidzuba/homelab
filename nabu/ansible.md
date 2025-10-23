# Ansible

We describe here the use of ansible for several contexts:

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

Note: in thje initial state of our VMs, the root password is enabled and `sudo` is not installed. We will install sudo using ansible,
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

### Testing

To perform that test, or running ansible in general, one needs to run the ssh agent:

    eval "$(ssh-agent)"
    ssh-add ~/.ssh/id_ed25519

To test that ansible works:

    ansible -u vassili -i "adad1,adad2,adad3" all -m ping
    ansible -u root -i "adad1,adad2,adad3" all -m ping

### 
