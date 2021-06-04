#!/bin/sh

BACKUP_PATH="/storage/backup/"
BACKUP_FILE=$BACKUP_PATH$(hostname).tgz
BACKUP_FILE_OLD=$BACKUP_FILE".old"

REMOTE_BACKUP_HOST="kyleh@syntax.l.tacomafia.net"
REMOTE_BACKUP_PATH=/srv/backup/devices/$(hostname)/

set -e

# Save off old backup file
if [ -f "$BACKUP_FILE" ]; then
    mv -f "$BACKUP_FILE" "$BACKUP_FILE_OLD"
fi

# Generate LibreElec compatible backup (must be decompressed and /flash removed to restore via GUI)
/usr/bin/tar cz -C / -f "$BACKUP_FILE" --exclude='storage/.ssh/id_ed25519' --exclude='storage/.cache/swapfile' --exclude='storage/.kodi/userdata/Thumbnails' --exclude='storage/.kodi/addons/packages' storage/.bin/ storage/.cache/ storage/.config/ storage/.kodi/ storage/.ssh/ storage/.vim/ flash/config.txt flash/cmdline.txt flash/edid.dat

# Copy new backup file to remote host
/usr/bin/scp -q "$BACKUP_FILE" $REMOTE_BACKUP_HOST:"$REMOTE_BACKUP_PATH"

exit 0
