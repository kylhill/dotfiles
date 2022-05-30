#!/bin/bash
#
# Script to backup a large dataset using rsync that spans multiple smaller drives
#
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
EMAIL_NOTIFY=kylhill@gmail.com

cleanup() {
    rm -f "$INCLUDE"
}

set -e
trap 'cleanup' EXIT

if [ $# -ne 2 ]; then
    echo "Usage: backup-span.sh SOURCE DEST"
    exit 1
fi

SRC="$1"
DEST="$2"

# Make sure paths always end in a trailing slash
SRC="${SRC%/}/"
DEST="${DEST%/}/"

if [ ! -d "$SRC" ]; then
    echo "Invalid source directory: $SRC"
    exit 1
fi
if [ ! -d "$DEST" ]; then
    echo "Invalid destination directory: $DEST"
    exit 1
fi

# Count slashes
SRC_SLASHES=$((  $(echo "$SRC"  | tr -cd '/' | wc -c) + 1 ))
DEST_SLASHES=$(( $(echo "$DEST" | tr -cd '/' | wc -c) + 1 ))

# Generate list of files to backup
INCLUDE="$(mktemp)"
find "$SRC" -name '*.zfs' -prune -o -type f -print | cut -sd / -f "$SRC_SLASHES"- | sort -u > "$INCLUDE"

# Remove empty directories from destination
find "$DEST" -type d -empty -delete

# rsync files from include list to destination
until rsync -arm --delete --progress --files-from="$INCLUDE" "$SRC" "$DEST"
do
    # Remove empty directories from destination
    find "$DEST" -type d -empty -delete

    # Remove files backed up to this drive from the include list
    TMP_EXCLUDE="$(mktemp)"
    find "$DEST" -type f -print | cut -sd / -f "$DEST_SLASHES"- | sort -u > "$TMP_EXCLUDE"

    TMP_INCLUDE="$(mktemp)"
    comm -23 "$INCLUDE" "$TMP_EXCLUDE" > "$TMP_INCLUDE"
    mv "$TMP_INCLUDE" "$INCLUDE"

    rm -f "$TMP_EXCLUDE"

    #echo "Backup drive $DEST is full. Ready to swap in a new drive." | mail -s "Syntax: $SRC Backup Drive Full" "$EMAIL_NOTIFY"
    read -r -p "Drive $DEST full. Swap in new drive, free up some space, and press any key to continue..."
done

#echo "Backup of $SRC to $DEST is complete." | mail -s "Syntax: $SRC Backup Complete" "$EMAIL_NOTIFY"
echo "Backup of $SRC to $DEST is complete."

exit 0
