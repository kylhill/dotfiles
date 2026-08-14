#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: ${BASH_COMMAND:-unknown command}" >&2' ERR

script_path=$(readlink -f -- "${BASH_SOURCE[0]}")
repo_root=$(cd -- "$(dirname -- "$script_path")/.." && pwd -P)
local_bin="$HOME/.local/bin"
migration_dir=""

if [[ -L "$local_bin" ]]; then
    linked_directory=$(readlink -f -- "$local_bin")

    if [[ "$linked_directory" != "$repo_root/bin" ]]; then
        echo "Error: $local_bin points to $linked_directory, not $repo_root/bin" >&2
        echo "No changes were made." >&2
        exit 1
    fi

    migration_dir=$(mktemp -d)
    echo "Preserving existing binaries in $migration_dir"
    cp -a -- "$local_bin/." "$migration_dir/"

    unlink -- "$local_bin"
    mkdir -p -- "$local_bin"
    cp -a -- "$migration_dir/." "$local_bin/"

    echo "Replaced the old $local_bin symlink with a real directory."
else
    mkdir -p -- "$local_bin"
    echo "$local_bin is already a real directory."
fi

"$repo_root/install"

if [[ -n "$migration_dir" ]]; then
    rm -rf -- "$migration_dir"
fi

echo "Migration complete. Repository-owned binaries are now linked individually."
