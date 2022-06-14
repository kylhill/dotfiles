#!/bin/sh
#
# Script to update and clean Kodi texturecache, intended to be called from a systemd service
#
PATH=/usr/bin:/usr/sbin:/storage/.kodi/addons/virtual.network-tools/bin:/storage/.kodi/addons/virtual.system-tools/bin
CONFIG=/storage/.config/texturecache.cfg
SYNC_HOSTS="htpc htpc2 htpc4"

# Cache missing thumbnails
cache() {
    texturecache.py @config="$CONFIG" c || error_exit
}

# Clean up old thumbnails and remove obsolete texturecache database entries
clean() {
    texturecache.py @config="$CONFIG" P || error_exit
    texturecache.py @config="$CONFIG" R || error_exit
}

error_exit() {
    #curl -fsS --retry 3 -o /dev/null https://hc-ping.com/c5012e7b-fd13-4c87-88b9-a49631c75757/$?
    exit 1
}

case "$1" in
cache)
    cache
    ;;
clean)
    clean
    ;;
*)
    echo "Usage: $0 {cache|clean}" >&2
    exit 1
    ;;
esac

fstrim -a

# Sync texture cache database and thumbnails to other hosts that share Kodi database
for i in $SYNC_HOSTS; do
    rsync -aq --delete /storage/.kodi/userdata/Database/Textures13.db "$i":/storage/.kodi/userdata/Database/Textures13.db && \
    rsync -aq --delete /storage/.kodi/userdata/Thumbnails/ "$i":/storage/.kodi/userdata/Thumbnails/ && \
    ssh "$i" "/usr/sbin/fstrim -a"
done

# Ping Healthchecks.io - https://healthchecks.io/docs/monitoring_cron_jobs/
curl -fsS --retry 3 -o /dev/null https://hc-ping.com/c5012e7b-fd13-4c87-88b9-a49631c75757

exit 0
