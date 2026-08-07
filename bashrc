# shellcheck shell=bash
# shellcheck disable=SC2034

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"

_term_colors=0
if command -v tput >/dev/null 2>&1; then
    _term_colors="$(tput colors 2>/dev/null || printf '0')"
fi
if [[ "${TERM:-}" != "linux" && "$_term_colors" =~ ^[0-9]+$ && "$_term_colors" -ge 256 ]]; then
    fancy_terminal=true
else
    fancy_terminal=false
fi
unset _term_colors

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
OSH_THEME="agnoster"

# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")
# You can also specify the list from which a theme is randomly selected:
# OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
    docker
    git
    ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
    general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sudo
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

# If you want to reduce the initialization cost of the "tput" command to
# initialize color escape sequences, you can uncomment the following setting.
# This disables the use of the "tput" command, and the escape sequences are
# initialized to be the ANSI version:
#
OMB_TERM_USE_TPUT=no

if [[ ${PREFIX:-} == *com.termux* || -v KASM_SSH ]]; then
    # Don't load oh-my-bash in Termux or Kasm SSH sessions

    # Dircolors
    if command -v dircolors >/dev/null 2>&1; then
        [[ -r ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    fi

    # Bash Completion
    for f in \
        "$PREFIX/share/bash-completion/bash_completion" \
        "$PREFIX/etc/bash_completion" \
        "/etc/bash_completion"; do
        # shellcheck source=/dev/null
        [[ -r "$f" ]] && source "$f" && break
    done
else
    # Load oh-my-bash for everything else
    if [[ -r "$OSH/oh-my-bash.sh" ]]; then
        source "$OSH/oh-my-bash.sh"
    else
        printf 'Oh My Bash not found: %s\n' "$OSH/oh-my-bash.sh" >&2
    fi
fi

# User configuration

export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%F %T "
export HISTSIZE=10000
export HISTFILESIZE=20000
export GLOBIGNORE=".*:node_modules:venv"

if [ -t 1 ]; then
    stty -ixon 2>/dev/null || true
fi

# Only complete directory names with cd
complete -d cd

# Minimal aliases - https://github.com/ohmybash/oh-my-bash/wiki/minimal_aliases
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias ls='ls --color=auto -h'

alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

alias ll='ls -alFh --color=auto'
alias la='ls -Ah --color=auto'
alias l='ls -CFh --color=auto'
alias cls='clear'

alias ..='cd ..'
alias ...='cd ../../'

alias bashreload='source ~/.bashrc && echo Sourced ~/.bashrc!'

if command -v nvim >/dev/null 2>&1 &&
    [[ "$fancy_terminal" == true && ${PREFIX:-} != *com.termux* && ! -v KASM_SSH ]]; then
    # Set default editor to nvim on supported fancy terminals
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man! -"

    alias vim=nvim
    alias vimdiff='nvim -d'
else
    # Otherwise, use vim
    export EDITOR="vim"
    export VISUAL="vim"
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
    local exclude="${1:-minecraft}"
    echo "Pruning Docker resources (excluding: $exclude)..."

    # Remove stopped containers, skipping any whose name matches the exclusion pattern
    docker ps -a --filter status=exited --filter status=created --format '{{.Names}}' |
        grep -Fv -- "$exclude" |
        xargs -r docker rm

    # Prune images not referenced by any remaining container
    docker image prune -a -f

    # Remove unused custom networks, explicitly skipping excluded ones.
    # docker network prune only protects running containers; stopped containers
    # don't count, so we must do this manually.
    docker network ls --format '{{.Name}}' --filter type=custom |
        grep -Fv -- "$exclude" |
        xargs -r docker network rm 2>/dev/null || true

    # Prune anonymous and dangling volumes
    docker volume prune -f

    # Prune build cache
    docker builder prune -f
}

# Use local ssh-agent, if available
if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
