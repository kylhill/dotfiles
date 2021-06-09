#!/bin/sh

# Generate updated shared file directory listings to aid in recovery -D
find -O3 /srv/shared/ -maxdepth 3 -type d -print | sort -h > /srv/backup/devices/syntax/misc/syntax_dirlist.txt
ls /srv/shared/books/ > /srv/backup/devices/syntax/misc/books_list.txt
ls /srv/shared/video/Movies/ > /srv/backup/devices/syntax/misc/movies_list.txt

# rsync unifi backups
/usr/bin/rsync -a --delete --quiet /opt/appdata/unifi-controller/data/backup/autobackup/ /srv/backup/devices/unifi/

# Generate gateway backup
ssh gateway tar -cz /config > /srv/backup/devices/gateway/gateway.tgz 2>/dev/null

exit 0
