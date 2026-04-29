#!/bin/bash

sudo mkdir /tmp/vm-share
sudo /usr/lib/virtiofsd --socket-path /tmp/vm-share.sock --socket-group kvm --shared-dir /tmp/vm-share
