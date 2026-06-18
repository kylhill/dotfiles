#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO: ${BASH_COMMAND:-unknown command}" >&2' ERR

INFRA_DIR="${INFRA_DIR:-$HOME/infra}"
PLAYBOOK="${PLAYBOOK:-site.yml}"

# Defaults (can be overridden by flags)
TAGS="${TAGS:-update}"
LIMIT="${LIMIT:-}"
DIFF="${DIFF:-0}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options (Ansible-compatible):
  -l, --limit HOSTS       Limit to hosts
  -t, --tags TAGS         Only run tagged tasks (default: $TAGS)
  -D, --diff              Show diffs
  -h, --help              Show this help

Environment variables (as defaults):
  INFRA_DIR, PLAYBOOK, TAGS, LIMIT, DIFF
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l|--limit)
      if [[ $# -lt 2 || -z "$2" ]]; then
        echo "Option $1 requires a host limit" >&2
        usage >&2
        exit 2
      fi
      LIMIT="$2"
      shift 2
      ;;
    -t|--tags)
      if [[ $# -lt 2 || -z "$2" ]]; then
        echo "Option $1 requires a tag list" >&2
        usage >&2
        exit 2
      fi
      TAGS="$2"
      shift 2
      ;;
    -D|--diff)
      DIFF=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

# Warn if running as root
if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
  echo "WARNING: Running as root. Consider using a normal user with become." >&2
fi

# Prerequisites
if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook not found in PATH" >&2
  exit 1
fi

[[ -d "$INFRA_DIR" ]] || {
  echo "Infra directory not found: $INFRA_DIR" >&2
  exit 1
}

[[ -f "$INFRA_DIR/$PLAYBOOK" ]] || {
  echo "Playbook not found: $INFRA_DIR/$PLAYBOOK" >&2
  exit 1
}

cd "$INFRA_DIR" || {
  echo "Failed to cd into $INFRA_DIR" >&2
  exit 1
}

# Build ansible-playbook arguments
ARGS=(
  "$PLAYBOOK"
  -t "$TAGS"
)

[[ "$DIFF" == "1" ]] && ARGS+=(--diff)
[[ -n "$LIMIT" ]] && ARGS+=(-l "$LIMIT")

# Echo command for visibility over SSH
echo "Running: ansible-playbook ${ARGS[*]}" >&2

ansible-playbook "${ARGS[@]}"
