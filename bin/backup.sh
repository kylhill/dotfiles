#!/bin/sh

BACKUP_PATH=/storage/backup/
BACKUP_FILE=$BACKUP_PATH$(date +%Y%m%d%H%M%S).tgz

REMOTE_BACKUP_HOST=kyleh@syntax.l.tacomafia.net
REMOTE_BACKUP_PATH=/srv/backup/$(hostname)/

set -e

# Generate LibreElec compatible backup
/usr/bin/tar cz -C / -f "$BACKUP_FILE" --exclude='storage/.cache/swapfile' --exclude='storage/.kodi/userdata/Thumbnails' storage/.cache/ storage/.config/ storage/.kodi/ storage/.ssh/ flash/config.txt flash/cmdline.txt flash/edid.dat

# Remove old local backup files
find $BACKUP_PATH*.tgz -mtime +30 -exec rm {} \; || true

# Copy new backup file to remote host
/usr/bin/scp -q "$BACKUP_FILE" $REMOTE_BACKUP_HOST:"$REMOTE_BACKUP_PATH"

# Remove old backup files on remote host
/usr/bin/ssh $REMOTE_BACKUP_HOST "find $REMOTE_BACKUP_PATH*.tgz -mtime +30 -exec rm {} \;" || true

exit 0
