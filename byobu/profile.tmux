source $BYOBU_PREFIX/share/byobu/profiles/tmux

# Use 256 color tmux if terminal supports it
if-shell 'test $(tput colors) -ge 256' 'set-option -g default-terminal "tmux-256color"'
if-shell 'test $(tput colors) -lt 256' 'set-option -g default-terminal "tmux"'

# Instructs tmux to expect UTF-8 sequences
setw -g utf8 on
set -g status-utf8 on

# Use vi-style key bindings in the status line
set -g mode-keys vi

# xterm-style function key sequences
setw -g xterm-keys on

# Start window numbers at 1 to match keyboard order with tmux window order
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows sequentially after closing any of them
set -g renumber-windows on
setw -g automatic-rename on

# Monitor activity
setw -g monitor-activity on

# Rather than constraining window size to the maximum size of any client
# connected to the *session*, constrain window size to the maximum size of any
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

# My attempt at a Solarized dark color scheme
#############################################

# pane border
set-option -g pane-active-border-fg $BYOBU_HIGHLIGHT
set-option -g pane-active-border-bg $BYOBU_DARK
set-option -g pane-border-fg $BYOBU_ACCENT
set-option -g pane-border-bg $BYOBU_DARK

# pane number display
set-option -g display-panes-active-colour $BYOBU_HIGHLIGHT
set-option -g display-panes-colour $BYOBU_ACCENT

# window mode
set-option -g mode-fg $BYOBU_LIGHT
set-option -g mode-bg $BYOBU_DARK

# default status bar colors
set -g status-fg $BYOBU_LIGHT
set -g status-bg $BYOBU_DARK

# default window title colors
set-window-option -g window-status-fg $BYOBU_LIGHT
set-window-option -g window-status-bg $BYOBU_DARK

# active window title colors
set-window-option -g window-status-current-fg $BYOBU_HIGHLIGHT
set-window-option -g window-status-current-bg $BYOBU_BRIGHT
set-window-option -g window-status-current-attr reverse

# window activity colors
set-window-option -g window-status-activity-fg $BYOBU_LIGHT
set-window-option -g window-status-activity-bg $BYOBU_DARK
set-window-option -g window-status-activity-attr bold

# message text
set-option -g message-fg $BYOBU_LIGHT
set-option -g message-bg $BYOBU_DARK

# clock
set-option -g clock-mode-colour $BYOBU_ACCENT
