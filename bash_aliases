# Handy docker aliases - https://docs.linuxserver.io/general/docker-compose
alias dtail='docker logs -tf --tail="150" "$@"'
alias dprune='docker system prune -a -f --volumes'

alias bashreload='source ~/.bashrc && echo Bash config reloaded;'

# Default psql to use postgres user
alias psql='psql -U postgres'

if [ -x "$PREFIX/bin/nvim" ]; then
    alias vim="$PREFIX/bin/nvim"
    alias vimdiff="$PREFIX/bin/nvim -d"
fi
