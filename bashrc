# Exit if not interactive
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoredups:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T "

shopt -s histappend
if [[ -n "${PROMPT_COMMAND:-}" ]]; then
    PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
else
    PROMPT_COMMAND="history -a; history -n;"
fi

# Shell options
shopt -s checkwinsize globstar autocd cdspell dirspell

# Disable XON/XOFF
if [ -t 1 ]; then
    stty -ixon 2>/dev/null || true
fi

# termux compatibility: Set PREFIX to /usr if not already set
PREFIX="${PREFIX:-/usr}"

# lesspipe
command -v lesspipe >/dev/null 2>&1 && eval "$(SHELL=$PREFIX/bin/sh lesspipe)"

# Color support: ensure tput exists and terminal supports colors
if command -v tput >/dev/null 2>&1; then
    COLORS="$(tput colors 2>/dev/null || echo 0)"
else
    COLORS=0
fi

if [ "$COLORS" -ge 8 ]; then
    # Prompt with colors
    PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

    # Dircolors
    if command -v dircolors &>/dev/null; then
        [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi

    # Colorize common commands
    alias ls='ls --color=auto -h'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip -color=auto'

    export LESS='-R --use-color -Dd+g -Du+b -M -J'
else
    PS1='\u@\h:\w\$ '
fi

# Source alias definitions
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# Bash Completion
if ! shopt -oq posix; then
  for f in \
    "$PREFIX/share/bash-completion/bash_completion" \
    "$PREFIX/etc/bash_completion" \
    "/etc/bash_completion"; do
      [[ -f "$f" ]] && source "$f" && break
  done
fi

# Exports
command -v less &>/dev/null && export PAGER="less"

# set default editor to nvim, if it exists, otherwise use vim
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
    export VISUAL=nvim
    export MANPAGER="nvim +Man!"
else
    export EDITOR=vim
    export VISUAL=vim
    export MANPAGER="vim -M +MANPAGER -"
fi

export GPG_TTY="$(tty 2>/dev/null || true)"

# Docker helpers
dbash() {
    if ! command -v docker >/dev/null 2>&1; then
        printf '%s\n' "docker: command not found" >&2
        return 127
    fi
    if [[ -z "${1:-}" ]]; then
        printf '%s\n' "usage: dbash <container>" >&2
        return 2
    fi
    if docker exec -it "$1" bash -c 'true' >/dev/null 2>&1; then
        docker exec -it "$1" bash
    else
        docker exec -it "$1" sh
    fi
}
dsh() {
    if ! command -v docker >/dev/null 2>&1; then
        printf '%s\n' "docker: command not found" >&2
        return 127
    fi
    if [[ -z "${1:-}" ]]; then
        printf '%s\n' "usage: dsh <container>" >&2
        return 2
    fi
    docker exec -it "$1" sh
}
