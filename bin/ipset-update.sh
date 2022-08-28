#!/bin/bash
#
# Script to download and apply ipsets, intended to be called from a systemd service
#
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

declare -A NETSETS
NETSETS["firehol_level1"]="https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset"

declare -A IPSETS
IPSETS["doh_servers"]="https://raw.githubusercontent.com/oneoffdallas/dohservers/master/iplist.txt"
#IPSETS["doh_servers_v6"]="https://raw.githubusercontent.com/oneoffdallas/dohservers/master/ipv6list.txt"

IPSET_DIR="/etc/firehol/ipsets/"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}

error_exit() {
    cleanup
    curl -fsS --retry 3 -o /dev/null https://hc-ping.com/a2eb4fdb-3511-4ed6-8f56-c1fc7e350756/$?
    exit 1
}

# Download and apply netsets
for i in "${!NETSETS[@]}"; do
    TMP_OUT="$TMP_DIR"/$i.netset
    curl -fsS --retry 3 -o "$TMP_OUT" "${NETSETS[$i]}" || error_exit
    ipset-apply.sh "$TMP_OUT" || error_exit
    mv -f "$TMP_OUT" "$IPSET_DIR" || error_exit
done

# Download and apply ipsets
for i in "${!IPSETS[@]}"; do
    TMP_OUT="$TMP_DIR"/$i.ipset
    curl -fsS --retry 3 -o "$TMP_OUT" "${IPSETS[$i]}" || error_exit
    ipset-apply.sh "$TMP_OUT" || error_exit
    mv -f "$TMP_OUT" "$IPSET_DIR" || error_exit
done

# Cleanup
cleanup

# Ping Healthchecks.io - https://healthchecks.io/docs/monitoring_cron_jobs/
curl -fsS --retry 3 -o /dev/null https://hc-ping.com/a2eb4fdb-3511-4ed6-8f56-c1fc7e350756

exit 0
