# Ansible

note: this is only the history of learning experiments with Ansible.

They are based on the youtube playlist by xavki [https://www.youtube.com/watch?v=kzmvwc2q_z0&list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-](https://www.youtube.com/watch?v=kzmvwc2q_z0&list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-).


We will use ansible from inside a container, with podman, using the image:

    podman pull docker.io/alpine/ansible:2.18.1

As suggested in the documentation of the container, we define two aliases:

    alias ansible='podman run -ti --rm -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v ~/.ssh:/root/.ssh -v $(pwd):/apps -w /apps docker.io/alpine/ansible:2.18.1 ansible'
    alias ansible-playbook='podman run -ti --rm -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v ~/.ssh:/root/.ssh -v $(pwd):/apps -w /apps docker.io/alpine/ansible:2.18.1 ansible-playbook'
    
Note that `-v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent` allows ssh agent forwarding, so that we don"t have to give the passphrase when in the container.

Important: these aliases must be defined *after* launching the ssh agent.

The target of our experimentations will be the machines *nidabaX*.

## Distribute keys

We copy the public keys of podman to the three servers. Note that at this stage, only one user exists on the managed machines (podman doesn't exists yet).

    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba1.manul.lan
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba2.manul.lan
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba3.manul.lan

## Ping

To test that ansible works:

    ansible -u vassili -i "nidaba1.manul.lan," all -m ping
    
## Execute a command

To execute a command (here `uptime`) one can use the module *command*:

    ansible -u vassili -i "nidaba1.manul.lan," all -m command -a uptime

One can also use the module *shell*:

    ansible -u vassili -i "nidaba1.manul.lan," all -m shell -a "lsblk | grep sda -"

## Use inventory

The inventory file `00-inventory.yml`, will contain:

    ---
    all:
      children:
        vbox:
          hosts:
            nidaba1.manul.lan:
            nidaba2.manul.lan:
            nidaba3.manul.lan:

To avoid warnings about the discovery of python, one define the file `group_vars/all/variables.yml` that contains:

    ansible_python_interpreter: "/usr/bin/python3"

We can now use the inventory as such:

    ansible -i 00-inventory.yml -u vassili -m ping all


## Using Ansible to test on containers

To be able to have fresh installs, Xavki suggest to use containers as the target of the Ansible runs. The image of the target is
given in [https://gitlab.com/xavki/presentation-ansible-fr/-/blob/master/14-plateforme-dev-docker/Dockerfile?ref_type=heads](https://gitlab.com/xavki/presentation-ansible-fr/-/blob/master/14-plateforme-dev-docker/Dockerfile?ref_type=heads). We will simply modify it to use a more recent version of debian: `docker.io/library/debian!stable` and remove the `stretch-backports`..

The tag of the image will be `192.168.0.20:5000/ansible-playground-debian:latest`.

The build command is:

    podman build -t 192.168.0.20:5000/ansible-playground-debian:latest -f Dockerfile

To use that approach, we need ro run rootful containers, so that podman can create a bridge network.
As user `podman` is not a sudoer, we create the containers using user `vassili` but will still run ansible from user `podman`.

To control the containers, we use the script [https://gitlab.com/xavki/presentation-ansible-fr/-/blob/master/14-plateforme-dev-docker/new_deploy.sh?ref_type=heads](). We oerform the following modifications:

* we use the `id_ed25519.pub` key instead of `id_rsa.pub`
* we use our container image
* we replace /srv/data by /home/podman/ansible/data
* we perform a `sudo podman pull  --tls-verify=false 192.168.0.20:5000/ansible-playground-debian:latest`
* we create the ansible directory in podman home directory

The ansible directory (set in the script) is `/home/podman/ansible/withdocker`.

We can then go in the ansible directory and run

    ansible -i 00-inventory.yml -u podman -m ping all
    
### Hosts

As we stop and restart these containers, the IP address changes. To keep the playbook valid, we add the containers IP addresses
to the DNS into a domain called ansible.lan.
Its configuration file is in `/usr/local/etc/bind/ansible-lan.zone` and contains the declarations

    alpha    IN    A     10.88.0.42
    beta     IN    A     10.88.0.43
    gamma    IN    A     10.88.0.44

where the actual IP addresses will need to change when the containers are restarted.

note: after restart of the containers, the sshd server wasn't running.

