# DAMU1

Damu1 is a ubuntu server running in a proxmox VM.
It has been added to the domain `manul.lan`.

The installations on `damu1` will be done using user `podman`.



## Distribute keys

We copy the public keys of podman to the server. Note that at this stage, only one user exists on the managed machines (podman doesn't exists yet).

    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@damu1.manul.lan

## Ping

To test that ansible works:

    ansible -u vassili -i "damu1.manul.lan," all -m ping

## Update docker image

We use podman to run ansible, but the ansible image from docker.io/alpine lacks a python library `passlib`.
We rebuild an ansible image with the dockerfile


```
FROM docker.io/library/alpine:3

RUN apk add --update --no-cache ansible bash openssh sshpass rsync py3-passlib

ENTRYPOINT []
CMD ["ansible", "--help"]
```

That image can be built by the command:

    podman build -f Dockerfile -t 192.168.0.20:5000/ansible:1.0


## Use inventory

The inventory file `00-inventory.yml`, will contain:

```yaml
---
all:
  hosts:
    damu1.manul.lan:
```

To avoid warnings about the discovery of python, one define the file `group_vars/all/variables.yml` that contains:

    ansible_python_interpreter: "/usr/bin/python3"

We can now use the inventory as such:

    ansible -i 00-inventory.yml -u vassili -m ping all

## Playbooks

###  01-hello-world.yml

This is a simple playbok that display a message.

```yaml
- name: hello world playbook
  hosts: all
  remote_user: vassili
  tasks:
  - name: display message
    debug:
      msg: "Hello world !"
```

It is run with the command:

    ansible-playbook -i 00-inventory.yml 01-hello-world.yml

###  02-create-user-podman.yml

This playbook creates a new user, names `podman`. The password is specified in the command line, not theplaybook.

```yaml
- name: create user podman
  hosts: all
  remote_user: vassili
  become: yes
  tasks:
  - name: create user
    user:
      name: podman
      state: present
      update_password: on_create
      password: "{{ password | password_hash('sha512') }}"
```

Note: if `update_password: on_create` is missing, then Ansible will consider that the user will change at each run.

The command will be;

    ansible-playbook -i 00-inventory.yml -K 02-create-user-podman.yml --extra-vars "password=foo"

### 03-upgrade.yml

This playbook upgrades the system and reboot it.

```yaml
- name: upgrade packages
  hosts: all
  remote_user: vassili
  become: yes
  tasks:
  - name: upgrade
    apt:
      update_cache: yes
      cache_valid_time: 3600
      upgrade: yes
  - name: reboot
    reboot:
      msg: "Reboot via ansible"
      connect_timeout: 5
      reboot_timeout: 300
      pre_reboot_delay: 0
      post_reboot_delay: 30
      test_command: uptime
```

### 04-nginx-install.yaml

This playboot install nginx.

```yaml
- name: install nginx
  hosts: all
  remote_user: vassili
  become: yes
  tasks:
  - name: install
    apt:
      name: nginx
      state: present
```

### 05-copy-ssh-key.yml

We will copy the public keys of user *podman*, which is the user executing the playbook.
Note that ansible is run in the container, not on the local host. Therefore, the public key is
in `/root/.ssh/id_ed25519.pub` due to the volume mapping specified i, the ansible-playbook alias, and not 
in `~/.ssh/id_ed255519.pub` which is the file path in the local host.


```yaml
- name: deploy ssh key
  hosts: all
  remote_user: vassili
  become: yes
  tasks:
  - name: Deploy
    authorized_key:
      user: podman
      key: "{{ lookup('file', '/root/.ssh/id_ed25519.pub') }}"
      state: present
```

The playbook will be run by the command:

    ansible-playbook -i 00-inventory.yml -K 05-copy-ssh-keys.yaml

After executing the playbook, user *podman* can ssh into damu1 using:

    ssh damu1.manul.lan

### 06-change-dns.yml

We will change the DNS used by the target machine. As it uses *netplan* and there is no builtin role for
netplan in ansible, we will wimply copy file configuration file.

The configuration file will in be `files/50-cloud-init.yaml` and will contain::

```yaml
network:
  version: 2
  ethernets:
    enp6s18:
      nameservers:
        addresses: [192.168.0.20, fd0f:ee:b0::1]
      dhcp4: true
      dhcp6: true
```

The playbook will be:

```yaml
- name: change DNS
  hosts: all
  remote_user: vassili
  become: yes
  tasks:
  - name: copy netplan config file
    copy:
      src: ./files/50-cloud-init.yaml
      dest: /etc/netplan/50-cloud-init.yaml
      backup: yes
      mode: 0600
      owner: root
      group: root
    register: netplan
  - name: apply changes
    command: /usr/sbin/netplan apply
    when: netplan.changed
```

We can run it with the command:

    ansible-playbook -i 00-inventory.yml -K 06-change-dns.yml
    
After running it, we can execute for instance

    ping odin.manul.lan

on *damu1*.
    