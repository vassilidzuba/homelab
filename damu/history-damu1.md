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

This playbook creates a new user, names `podman`, with password 'foo'.

```yaml
- name: create user podman
  hosts: all
  remote_user: vassili
  become_user: root
  tasks:
  - name: create user
    user:
      name: podman
      state: present
      update_password: on_create
      password: "{{ 'foo' | password_hash('sha512') }}"
```

Note: if `update_password: on_create` is missing, then Ansible will consider that the user will change at each run.
