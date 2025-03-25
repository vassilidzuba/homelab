# Ansible

note: this is only the history of learning experiments with Ansible.

They are based on the youtube playlist by xavki [https://www.youtube.com/watch?v=kzmvwc2q_z0&list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-](https://www.youtube.com/watch?v=kzmvwc2q_z0&list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-).


We will use ansible from inside a container, with podman, using the image:

    podman pull docker.io/alpine/ansible:2.18.1

As suggested in the documentation of the container, we define two aliases:

    alias ansible="podman run -ti --rm -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v ~/.ssh:/root/.ssh -v $(pwd):/apps -w /apps docker.io/alpine/ansible:2.18.1 ansible"
    alias ansible-playbook="podman run -ti --rm -v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent -v ~/.ssh:/root/.ssh -v $(pwd):/apps -w /apps docker.io/alpine/ansible:2.18.1 ansible-playbook"
    
Note that `-v $SSH_AUTH_SOCK:/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent` allows ssh agent forwarding, so that we don"t have to give the passphrase when in the container.

The target of our experimentations will be the machines *nidabaX*.

## Distribute keys

We copy the public keys of podman to the three servers. Note that at this stage, only one user exists on the managed machines (podman doesn't exists yet).

    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba1.manul.lan
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba2.manul.lan
    ssh-copy-id -i ~/.ssh/id_ed25519  vassili@nidaba3.manul.lan

## Ping

To test that ansible works:

    ansible --extra-vars "ansible_user=vassili"   -i "nidaba1.manul.lan," all -m ping