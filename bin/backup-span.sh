#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Bail immediately on errors
set -e
trap 'cleanup' EXIT

cleanup() {
    rm -f "$EXCLUDE"
    rm -f "$NEW_INCLUDE"
    rm -f "$DEST_FILES"
}

print_usage() {
    echo ""
    echo "Usage:  $0 [OPTIONS] SOURCE DEST"
    echo ""
    echo "Perform backup of a large dataset spanning multiple smaller drives."
    echo ""
    echo "Options:"
    echo "  -s  Save list for remaining files to back up, defaults to files.txt"
}

while getopts "s:" FLAG
do
    case "$FLAG" in
        s) INCLUDE=${OPTARG};;
        *) print_usage; exit 1;;
    esac
done

shift $((OPTIND - 1))
if [[ -z "$1" || -z "$2" ]]; then
    print_usage
    exit 1
fi

SRC="$1"
DEST="$2"

# Make sure paths always end in a trailing slash
SRC="${SRC%/}/"
DEST="${DEST%/}/"

if [[ ! -d "$SRC" ]]; then
    echo "Invalid source directory: $SRC"
    exit 1
fi
if [[ ! -d "$DEST" ]]; then
    echo "Invalid destination directory: $DEST"
    exit 1
fi
if [[ "$DEST" != /media* ]]; then
    echo "Safety check: $DEST not a child of /media"
    exit 1
fi

# Use default files.txt if not specified
if [[ -z "$INCLUDE" ]]; then
    INCLUDE="files.txt"
fi

remove_old_files() {
    set +e
    DEST_FILES="$(mktemp)"

    # Generate list of all files at destination
    # Don't delete any files in the special "_copy2" subdirectory
    echo "Deleting files from $DEST not found in $INCLUDE..."
    find "$DEST" -path "$DEST"_copy2 -prune -o -type f -print | cut -sd / -f "$DEST_SLASHES"- | sort -u > "$DEST_FILES"

    # Delete all files at destination that are not also at source
    while IFS= read -r FILE; do
        echo "Deleting $DEST$FILE"
        rm -f "$DEST$FILE"
    done < <(comm -13 "$INCLUDE" "$DEST_FILES")

    # Remove any left-over empty directories from destination
    find "$DEST" -type d -empty -delete

    rm -f "$DEST_FILES"
    set -e
}

# Count slashes
SRC_SLASHES=$((  $(echo "$SRC"  | tr -cd '/' | wc -c) + 1 ))
DEST_SLASHES=$(( $(echo "$DEST" | tr -cd '/' | wc -c) + 1 ))

# If $INCLUDE already contains items, use it.  Otherwise, generate a new list of items to backup
if [[ ! -s "$INCLUDE" ]]; then
    echo "Generating list of files from $SRC to backup..."
    find "$SRC" -type d -name '.zfs' -prune -o -type f -print | cut -sd / -f "$SRC_SLASHES"- | sort -u > "$INCLUDE"
else
    echo "Using list of files from $INCLUDE to backup..."
fi

remove_old_files

# rsync files from include list to destination
until rsync -arm --progress --files-from="$INCLUDE" "$SRC" "$DEST"; do
    # Remove any left-over empty directories from destination
    find "$DEST" -type d -empty -delete

    OLD_UUID="$(findmnt -no uuid -T "${DEST}")"

    read -r -p "Drive $DEST full? Free space or swap in new drive. Press any key to continue..."

    NEW_UUID="$(findmnt -no uuid -T "${DEST}")"

    # Get list of files backed up to destination
    EXCLUDE="$(mktemp)"
    find "$DEST" -type f -print | cut -sd / -f "$DEST_SLASHES"- | sort -u > "$EXCLUDE"

    # Remove files that have already been backed up fom $INCLUDE
    NEW_INCLUDE="$(mktemp)"
    comm -23 "$INCLUDE" "$EXCLUDE" > "$NEW_INCLUDE"
    mv "$NEW_INCLUDE" "$INCLUDE"
    rm -f "$EXCLUDE"

    if [[ "$OLD_UUID" != "$NEW_UUID" ]]; then
        echo "New drive, removing already backed-up files..."
        remove_old_files
    else
        echo "Same drive, continuing backup..."
    fi
done

rm -f "$INCLUDE"
echo "Backup of $SRC to $DEST is complete."

exit 0
