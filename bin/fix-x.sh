#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   sudo ./fix-x.sh /srv/samba/share
#   sudo ./fix-x.sh --dry-run /srv/samba/share
#
# This sets the Unix executable bit on files that Windows clients commonly execute.

DRY_RUN=0

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=1
    shift
fi

SHARE_ROOT="${1:-}"

if [[ -z "$SHARE_ROOT" ]]; then
    echo "Usage: $0 [--dry-run] /path/to/samba/share" >&2
    exit 1
fi

if [[ ! -d "$SHARE_ROOT" ]]; then
    echo "Error: '$SHARE_ROOT' is not a directory" >&2
    exit 1
fi

# Windows-executable-ish extensions.
# Add/remove extensions for your environment.
EXTENSIONS=(
    exe
    bat
    msi
    ps1
    reg
)

find_expr=()

for ext in "${EXTENSIONS[@]}"; do
    if [[ ${#find_expr[@]} -gt 0 ]]; then
        find_expr+=(-o)
    fi
    find_expr+=(-iname "*.${ext}")
done

echo "Scanning: $SHARE_ROOT"

if [[ "$DRY_RUN" -eq 1 ]]; then
    find "$SHARE_ROOT" -type f \( "${find_expr[@]}" \) -print
else
    find "$SHARE_ROOT" -type f \( "${find_expr[@]}" \) -print0 |
        while IFS= read -r -d '' file; do
            chmod a+x -- "$file"
            printf 'chmod a+x %q\n' "$file"
        done
fi
