#!/bin/sh
set -e

cd ~/infra
ansible-playbook site.yml -t update
