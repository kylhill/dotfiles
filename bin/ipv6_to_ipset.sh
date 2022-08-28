#!/bin/bash
#
# Super hacky script to convert ipv6list.txt from https://github.com/oneoffdallas/dohservers/blob/master/ipv6list.txt to ipset
# TODO: Clean this up!
#
file="./ipv6list.txt"
while read -r line; do
    [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]] && continue
    ipset add doh_servers_v6 "${line}"
done < "$file"

exit 0
