#!/usr/bin/env bash

set -euo pipefail
trap 'printf "Termux bootstrap failed at line %s\n" "$LINENO" >&2' ERR

if [[ -z "${PREFIX:-}" ]] || ! command -v pkg >/dev/null 2>&1; then
    printf 'Run this script inside Termux.\n' >&2
    exit 1
fi

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

pkg update
pkg upgrade -y

pkg install -y git starship vim dnsutils bash-completion

# Dotbot needs Python, but not pip.
pkg install -y --no-install-recommends python

# The installer initializes Dotbot; the color configuration also needs its submodule.
git submodule update --init --recursive
./install
