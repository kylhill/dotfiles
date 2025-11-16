# Exit if not interactive
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "

# Shell options
shopt -s histappend checkwinsize globstar autocd cdspell dirspell

# Disable XON/XOFF
if [ -t 1 ]; then
    stty -ixon 2>/dev/null || true
fi

# lesspipe
if command -v lesspipe >/dev/null && [[ -z "$LESSOPEN" ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# Color support: ensure terminal supports colors
if command -v tput >/dev/null 2>&1 && tput colors >/dev/null 2>&1; then
    # Prompt with colors
    PS1='\[\033[1;32m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '

    # Dircolors
    if command -v dircolors >/dev/null 2>&1; then
        [[ -z "$LS_COLORS" ]] && { [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"; }
    fi

    # Colorize common commands
    alias ls='ls --color=auto -h'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip -color=auto' 2>/dev/null

    export LESS='-R --use-color -Dd+g -Du+b -M -J'
else
    PS1='\u@\h:\w\$ '
fi

# Source alias definitions
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# termux compatibility: Set PREFIX to /usr if not already set
PREFIX="${PREFIX:-/usr}"

# Bash Completion
if ! shopt -oq posix; then
  for f in \
    "$PREFIX/share/bash-completion/bash_completion" \
    "$PREFIX/etc/bash_completion" \
    "/etc/bash_completion"; do
      [[ -r "$f" ]] && source "$f" && break
  done
fi

# Exports
command -v less >/dev/null 2>&1 && export PAGER="less"

# set default editor to nvim, if it exists, otherwise use vim
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="${EDITOR:-nvim}"
    export VISUAL="${VISUAL:-nvim}"
    export MANPAGER="nvim +Man! -"
else
    export EDITOR="${EDITOR:-vim}"
    export VISUAL="${VISUAL:-vim}"
    export MANPAGER="vim -M +':set ft=man' -"
fi

export GPG_TTY="$(tty 2>/dev/null)"

# Docker helpers
dbash() {
    command -v docker >/dev/null 2>&1 || { echo "docker not found" >&2; return 127; }
    [[ -n "$1" ]] || { echo "usage: dbash <container>" >&2; return 2; }

    local shell
    shell=$(docker exec "$1" sh -c 'command -v bash || command -v sh' 2>/dev/null) || {
        echo "container not found or no shell" >&2
        return 1
    }

    docker exec -it "$1" "$shell"
}
alias dsh=dbash

_complete_docker_containers() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers
    containers=$(docker ps --format '{{.Names}}' 2>/dev/null)
    COMPREPLY=( $(compgen -W "$containers" -- "$cur") )
}
complete -F _complete_docker_containers dbash dsh
