#!/bin/sh
#
# Update docker containers and install updates
#
set -e

docker-compose -f /opt/docker-compose.yml pull
docker-compose -f /opt/docker-compose.yml up -d
docker system prune -a -f --volumes

sudo aptitude update
sudo aptitude full-upgrade -r -y

#sudo fstrim -va

exit 0
