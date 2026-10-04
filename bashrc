# shellcheck shell=bash
# shellcheck disable=SC2034,SC1090,SC1091

# Shared interactive Bash configuration for Linux and Termux.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Ignore duplicate commands and commands starting with a space.
export HISTCONTROL=ignoreboth:erasedups

# Retain history across sessions.
export HISTSIZE=10000
export HISTFILESIZE=20000

# History, terminal sizing, globbing, and interactive shell conveniences.
shopt -s histappend checkwinsize globstar extglob checkjobs cdspell dirspell lithist

# Enable less preprocessing when available.
if command -v lesspipe >/dev/null 2>&1; then
    eval "$(SHELL="$(command -v sh)" lesspipe)"
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Use an ASCII fallback prompt with colors when supported.
if command -v tput >/dev/null 2>&1 && tput setaf 1 >/dev/null 2>&1; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Load completion once, using Termux or Linux installation paths.
if ! shopt -oq posix && [[ -z ${BASH_COMPLETION_VERSINFO:-} ]]; then
  if [ -n "${PREFIX:-}" ] && [ -f "$PREFIX/share/bash-completion/bash_completion" ]; then
    . "$PREFIX/share/bash-completion/bash_completion"
  elif [ -n "${PREFIX:-}" ] && [ -f "$PREFIX/etc/bash_completion" ]; then
    . "$PREFIX/etc/bash_completion"
  elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Personal shell customizations.
if [ -t 0 ]; then
    stty -ixon 2>/dev/null || true
fi

# Only complete directory names with cd
complete -d cd

# Prefer the best installed editor on every system.
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man! -"
    alias vim=nvim
    alias vimdiff='nvim -d'
else
    unalias vim vimdiff 2>/dev/null || true
    [[ ${MANPAGER:-} != 'nvim +Man! -' ]] || unset MANPAGER
    if command -v vim >/dev/null 2>&1; then
        export EDITOR="vim"
    else
        export EDITOR="vi"
    fi
    export VISUAL="$EDITOR"
fi

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    alias fd=fdfind
fi

if command -v less >/dev/null 2>&1; then
    export PAGER="less"
elif command -v more >/dev/null 2>&1; then
    export PAGER="more"
else
    export PAGER="cat"
fi

# Load Docker helpers only when the client is installed.
if command -v docker >/dev/null 2>&1 && [[ -r "$HOME/.config/bash/docker.bash" ]]; then
    # shellcheck source=bash/docker.bash
    source "$HOME/.config/bash/docker.bash"
fi

# Use local ssh-agent, if available
#if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
#    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
#fi

# Enable direnv integration
if command -v direnv >/dev/null 2>&1; then
    export DIRENV_LOG_FORMAT=""
    eval "$(direnv hook bash)"
fi

# Enable the Starship prompt when installed.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

# Allow machine-specific aliases and settings to override shared defaults.
if [ -r ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
