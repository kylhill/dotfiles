# Handy docker aliases - https://docs.linuxserver.io/general/docker-compose
alias dtail='docker logs -tf --tail="150" "$@"'
alias dprune='docker system prune -a -f --volumes'

alias bashreload='source ~/.bashrc && echo Bash config reloaded;'

# Default psql to use postgres user
alias psql='psql -U postgres'

# I accidentally type "lsl" more frequently than I'd like to admit
alias lsl='ls "$@"'

# Output full set of 256 termcolours for when I'm playing with colourschemes
alias termcolours='for x in 0 1 4 5 7 8; do for i in `seq 30 37`; do for a in `seq 40 47`; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo "";'
