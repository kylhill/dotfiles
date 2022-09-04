#!/bin/bash
#
# Script to backup a large dataset using rsync that spans multiple smaller drives
#
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cleanup() {
    rm -f "$INCLUDE"
    rm -f "$EXCLUDE"
    rm -f "$NEW_INCLUDE"
    rm -f "$DEST_FILES"
}

remove_old_files() {
    DEST_FILES="$(mktemp)"

    # Generate list of all files at destination
    echo "Deleting files from $DEST not found in list..."
    find "$DEST" -path "$DEST"_copy2 -prune -o -type f -print | cut -sd / -f "$DEST_SLASHES"- | sort -u > "$DEST_FILES"

    # Delete all files at destination that are not also at source
    while IFS= read -r FILE; do
        echo "Deleting $DEST$FILE"
        rm -f "$DEST$FILE"
    done < <(comm -13 "$INCLUDE" "$DEST_FILES")

    # Remove any left-over empty directories from destination
    find "$DEST" -type d -empty -delete

    rm -f "$DEST_FILES"
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
if [[ "$DEST" != /media* ]]; then
    echo "Safety check: $DEST not a child of /media"
    exit 1
fi

# Count slashes
SRC_SLASHES=$((  $(echo "$SRC"  | tr -cd '/' | wc -c) + 1 ))
DEST_SLASHES=$(( $(echo "$DEST" | tr -cd '/' | wc -c) + 1 ))

INCLUDE="$(mktemp)"

echo "Generating list of files from $SRC to backup..."
find "$SRC" -path "$SRC".zfs -prune -o -type f -print | cut -sd / -f "$SRC_SLASHES"- | sort -u > "$INCLUDE"

remove_old_files

# rsync files from include list to destination
until rsync -arm --progress --files-from="$INCLUDE" "$SRC" "$DEST"; do
    # Remove any left-over empty directories from destination
    find "$DEST" -type d -empty -delete

    # Get list of files backed up to drive
    EXCLUDE="$(mktemp)"
    find "$DEST" -type f -print | cut -sd / -f "$DEST_SLASHES"- | sort -u > "$EXCLUDE"

    OLD_UUID="$(findmnt -no uuid -T "${DEST}")"

    read -r -p "Drive $DEST full? Free space or swap in new drive. Press any key to continue..."

    NEW_UUID="$(findmnt -no uuid -T "${DEST}")"

    if [ "$OLD_UUID" != "$NEW_UUID" ]; then
        echo "New drive, removing backed-up files from list..."
        NEW_INCLUDE="$(mktemp)"
        comm -23 "$INCLUDE" "$EXCLUDE" > "$NEW_INCLUDE"
        mv "$NEW_INCLUDE" "$INCLUDE"

        remove_old_files
    else
        echo "Same drive, continuing backup..."
    fi

    rm -f "$EXCLUDE"
done

rm -f "$INCLUDE"
echo "Backup of $SRC to $DEST is complete."

exit 0
