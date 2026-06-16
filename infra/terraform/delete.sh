#!/bin/bash

terraform init -upgrade

terraform destroy -auto-approve

sudo virsh destroy debian-node1 2>/dev/null || true
sudo virsh undefine debian-node1 2>/dev/null || true

sudo virsh vol-delete --pool default debian-node1-cloudinit.iso 2>/dev/null || true
sudo virsh vol-delete --pool default debian-node1-disk.qcow2 2>/dev/null || true
sudo virsh vol-delete --pool default debian.qcow2 2>/dev/null || true

rm -f id_ed25519_debian
rm -f id_ed25519_debian.pub

ssh-keygen -f '~/.ssh/known_hosts' -R '192.168.122.101'
rm -f ~/.ssh/id_ed25519_debian
