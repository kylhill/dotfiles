#!/bin/sh
set -e

cd /home/kyleh/infra
ansible-playbook site.yml -t update

exit 0
