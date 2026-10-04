# shellcheck shell=bash
# Sourced by bashrc; do not change the interactive shell options.

# Docker helpers
dbash() {
    command -v docker >/dev/null 2>&1 || {
        echo "docker not found" >&2
        return 127
    }
    [[ -n "${1:-}" ]] || {
        echo "usage: dbash <container>" >&2
        return 2
    }

    local shell
    shell=$(docker exec "$1" sh -c 'command -v bash || command -v sh' 2>/dev/null) || {
        echo "container not found or no shell" >&2
        return 1
    }

    docker exec -it "$1" "$shell"
}
alias dsh=dbash

dtail() {
    docker logs -tf --tail="150" "$@"
}

_complete_docker_containers() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers
    local container
    containers=$(docker ps --format '{{.Names}}' 2>/dev/null)
    COMPREPLY=()
    while IFS= read -r container; do
        COMPREPLY+=("$container")
    done < <(compgen -W "$containers" -- "$cur")
}
complete -F _complete_docker_containers dbash dsh dtail

dprune() {
    local exclude_patterns=(-e minecraft -e forgejo)
    if [[ -n "${1:-}" ]]; then
        exclude_patterns+=(-e "$1")
    fi
    echo "Pruning Docker resources (excluding: minecraft, forgejo${1:+, $1})..."

    # Remove stopped containers, skipping any whose name matches the exclusion pattern
    docker ps -a --filter status=exited --filter status=created --format '{{.Names}}' |
        grep -Fv "${exclude_patterns[@]}" |
        xargs -r docker rm

    # Prune images not referenced by any remaining container
    docker image prune -a -f

    # Remove unused custom networks, explicitly skipping excluded ones.
    # docker network prune only protects running containers; stopped containers
    # don't count, so we must do this manually.
    docker network ls --format '{{.Name}}' --filter type=custom |
        grep -Fv "${exclude_patterns[@]}" |
        xargs -r docker network rm 2>/dev/null || true

    # Prune anonymous and dangling volumes
    docker volume prune -f

    # Prune build cache
    docker builder prune -f
}
