#!/bin/sh
set -e

pushd /home/kyleh/infra
ansible-playbook site.yml -t update
popd

exit 0
