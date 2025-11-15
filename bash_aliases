# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../../'

# Handy docker aliases - https://docs.linuxserver.io/general/docker-compose
alias dtail='docker logs -tf --tail="150" "$@"'
alias dprune='docker system prune -a -f --volumes'

alias bashreload='source ~/.bashrc && echo Bash config reloaded;'

# Default psql to use postgres user
alias psql='psql -U postgres'

if command -v nvim &>/dev/null; then
    alias vim="nvim"
    alias vimdiff="nvim -d"
    alias fd=fdfind
fi
