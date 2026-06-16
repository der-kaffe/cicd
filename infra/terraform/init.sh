#!/bin/bash

terraform init -upgrade

terraform apply -auto-approve

sleep 30

cp id_ed25519_debian ~/.ssh/
chmod 600 ~/.ssh/id_ed25519_debian

ssh-keygen -f '~/.ssh/known_hosts' -R '192.168.122.101'

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519_debian debian@192.168.122.101 "echo 'VM lista'"
