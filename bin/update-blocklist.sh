#!/bin/sh

set -e

BLACKLIST=/var/cache/dnscrypt-proxy/blacklist.txt

cd /opt/generate-domains-blocklist/

SHA_PRE=$(shasum "$BLACKLIST" | cut -d' ' -f1)
python3 generate-domains-blocklist.py -o $BLACKLIST

SHA_POST=$(shasum "$BLACKLIST" | cut -d' ' -f1)

# If the blacklist file was updated, restart dnscrypt-proxy
if [ "$SHA_PRE" != "$SHA_POST" ]; then
    systemctl force-reload dnscrypt-proxy.service
fi

exit 0
