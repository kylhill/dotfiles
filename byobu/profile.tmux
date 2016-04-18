source $BYOBU_PREFIX/share/byobu/profiles/tmux

# Use 256 color tmux if terminal supports it
if-shell 'test $(tput colors) -ge 256' 'set-option -g default-terminal "tmux-256color"'
if-shell 'test $(tput colors) -lt 256' 'set-option -g default-terminal "tmux"'

# Instructs tmux to expect UTF-8 sequences
setw -g utf8 on
set -g status-utf8 on

# Use vi-style key bindings in the status line
setw -g mode-keys vi

# xterm-style function key sequences
setw -g xterm-keys on

# Start window numbers at 1 to match keyboard order with tmux window order
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows sequentially after closing any of them
set -g renumber-windows on
setw -g automatic-rename on

# Rather than constraining window size to the maximum size of any client
# connected to the *session*, constrain window size to the maximum size of any
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

#### COLOR (Solarized dark)
# See: https://github.com/seebi/tmux-colors-solarized

# default statusbar colors
set-option -g status-bg black
set-option -g status-fg yellow
#set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg brightblue
set-window-option -g window-status-bg default
set-window-option -g window-status-attr default

# active window title colors
set-window-option -g window-status-current-fg colour12
set-window-option -g window-status-current-bg default
set-window-option -g window-status-current-attr reverse

# pane border
set-option -g pane-border-fg black
set-option -g pane-active-border-fg brightgreen

# message text
set-option -g message-bg black
set-option -g message-fg brightred

# pane number display
set-option -g display-panes-active-colour blue
set-option -g display-panes-colour brightred

# clock
set-window-option -g clock-mode-colour green

# bell
set-window-option -g window-status-bell-style fg=black,bg=red
