source $BYOBU_PREFIX/share/byobu/profiles/tmux

set -g default-terminal 'screen-256color'

set -g mode-keys vi

# moving between panes with vim movement keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

