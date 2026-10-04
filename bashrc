# shellcheck shell=bash
# shellcheck disable=SC2034,SC1090,SC1091

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=10000
export HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Additional interactive shell conveniences.
shopt -s extglob checkjobs cdspell dirspell lithist

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Appliance/mobile sessions keep the plain prompt and system editor.
_dotfiles_basic=false
if [[ ${PREFIX:-} == *com.termux* || -v KASM_SSH || ${TERM:-dumb} == dumb || ${TERM:-} == linux ]]; then
    _dotfiles_basic=true
fi

_term_colors=0
if command -v tput >/dev/null 2>&1; then
    _term_colors=$(tput colors 2>/dev/null || printf '0')
fi
fancy_terminal=false
if [[ $_dotfiles_basic == false && $_term_colors =~ ^[0-9]+$ && $_term_colors -ge 256 ]]; then
    fancy_terminal=true
fi
unset _dotfiles_basic _term_colors

# Use the system-style prompt, keeping basic terminals plain.
if [[ $fancy_terminal == true ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    # Set the terminal title on supported terminals.
    case "${TERM:-}" in
        xterm*|rxvt*)
            PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
            ;;
    esac
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load programmable completion once, including Termux installation paths.
if ! shopt -oq posix && [[ -z ${BASH_COMPLETION_VERSINFO:-} ]]; then
    _completion_paths=(/usr/share/bash-completion/bash_completion /etc/bash_completion)
    if [[ -n ${PREFIX:-} && $PREFIX != /usr ]]; then
        _completion_paths=("$PREFIX/share/bash-completion/bash_completion" "$PREFIX/etc/bash_completion" "${_completion_paths[@]}")
    fi
    for f in "${_completion_paths[@]}"; do
        [[ -r "$f" ]] && source "$f" && break
    done
    unset f _completion_paths
fi

if [ -t 0 ]; then
    stty -ixon 2>/dev/null || true
fi

# Only complete directory names with cd
complete -d cd

if [[ $fancy_terminal == true ]] && command -v nvim >/dev/null 2>&1; then
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

export PAGER="less"
if [[ -t 0 ]]; then
    GPG_TTY="$(tty)"
    export GPG_TTY
else
    unset GPG_TTY
fi

# Load Docker helpers only when the client is installed.
if command -v docker >/dev/null 2>&1 && [[ -r "$HOME/.config/bash/docker.bash" ]]; then
    # shellcheck source=bash/docker.bash
    source "$HOME/.config/bash/docker.bash"
fi

# Use local ssh-agent, if available
if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi

if command -v direnv >/dev/null 2>&1; then
    export DIRENV_LOG_FORMAT=""
    eval "$(direnv hook bash)"
fi
