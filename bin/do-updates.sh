#!/bin/sh
set -e

cd /home/kyleh/infra
ansible-playbook do-updates.yml -t update

exit 0
