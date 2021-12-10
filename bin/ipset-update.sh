#!/bin/sh
#
# Script to download and apply ipsets, intended to be called from a systemd service
#
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Source configuration
if [ -f "/etc/default/netfilter-persistent" ]; then
    . /etc/default/netfilter-persistent
else
    BLOCKLIST_SETS="firehol_level1"
fi

BASE_URL="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master"
BASE_DIR="/etc/firehol/ipsets"

TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

error_exit() {
    cleanup
    curl -fsS --retry 3 -o /dev/null https://hc-ping.com/a2eb4fdb-3511-4ed6-8f56-c1fc7e350756/$?
    exit 1
}

# Download ipsets
for i in $BLOCKLIST_SETS; do
    NETSET=$i.netset
    curl -fsS --retry 3 -o "$TMP_DIR"/$NETSET "$BASE_URL"/$NETSET || error_exit
    mv -f "$TMP_DIR"/$NETSET "$BASE_DIR"/$NETSET || error_exit
done

# Cleanup
cleanup

# Apply ipsets
ipset-apply.sh "$BLOCKLIST_SETS" || error_exit

# Ping Healthchecks.io - https://healthchecks.io/docs/monitoring_cron_jobs/
curl -fsS --retry 3 -o /dev/null https://hc-ping.com/a2eb4fdb-3511-4ed6-8f56-c1fc7e350756

exit 0
