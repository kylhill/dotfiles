#!/bin/sh
#
# Script to generate additional backup data, intended to be called from a backup script
#

# Generate an updated shared file manifest to aid in recovery
find /srv/shared/ -path '/srv/shared/.zfs' -prune -o -type f -print | cut -sd / -f 3- | sort -u > /srv/backup/devices/syntax/misc/shared_manifest.txt

# Generate htpc backups weekly
for i in htpc htpc2 htpc3 htpc4; do
    HTPC_BACKUP_DIR="/srv/backup/devices/$i/"
    mkdir -p $HTPC_BACKUP_DIR

    HTPC_BACKUP=$HTPC_BACKUP_DIR"$i.tar"
    if [ ! -f "$HTPC_BACKUP" ] || [ "$(find "$HTPC_BACKUP" -type f -daystart -mtime +6 -print)" ]; then
        ssh $i "tar -cf /storage/backup/$i.tar -C / \
                    --exclude='storage/.cache/swapfile' --exclude='storage/.kodi/userdata/Thumbnails' --exclude='storage/.kodi/addons/packages' --exclude='storage/.kodi/addons/virtual.system-tools' --exclude='storage/.kodi/addons/virtual.network-tools'\
                    storage/.cache/ storage/.config/ storage/.kodi/ storage/.ssh/ storage/.vim/ && \
                tar -cf /storage/backup/\"$i\"_flash.tar -C /flash config.txt cmdline.txt" &&
        scp -q $i:/storage/backup/$i.tar /srv/backup/devices/$i/$i.tar &&
        scp -q $i:/storage/backup/"$i"_flash.tar /srv/backup/devices/$i/"$i"_flash.tar
    fi
done

exit 0
