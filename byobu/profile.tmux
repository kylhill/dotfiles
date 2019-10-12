source $BYOBU_PREFIX/share/byobu/profiles/tmux

# Use 256 color tmux if terminal supports it
if-shell 'test $(tput colors) -ge 256' 'set-option -g default-terminal "screen.xterm-256color"'
if-shell 'test $(tput colors) -ge 256' 'set-option -ga terminal-overrides ",*-256color:Tc"'

# Make Ctrl+Left and Ctrl+Right work properly
set -ga terminal-overrides "xterm*:kLFT5=\eOD:kRIT5=\eOC:kUP5=\eOA:kDN5=\eOB:smkx@:rmkx@"

# Update terminal window title dynamically
set-option -g set-titles on
set-option -g set-titles-string '#(whoami)@#(hostname -f)'

# Start window numbers at 1 to match keyboard order with tmux window order
set-option -g base-index 1
set-window-option -g pane-base-index 1

# Renumber windows sequentially after closing any of them
set-option -g renumber-windows on

# Don't show hardcoded byobu date/time
set-option -g status-right '#(byobu-status tmux_right)'

# Solarized dark color scheme
#############################################

# pane border
set-option -g  pane-active-border-style bg=$BYOBU_DARK
set-option -ga pane-active-border-style fg=$BYOBU_HIGHLIGHT
set-option -g  pane-border-style fg=$BYOBU_ACCENT
set-option -ga pane-border-style bg=$BYOBU_DARK

# window mode
set-option -g  mode-style bg=$BYOBU_DARK
set-option -ga mode-style fg=$BYOBU_LIGHT


# default window title colors
set-window-option -g  window-status-style bg=$BYOBU_DARK
set-window-option -ga window-status-style fg=$BYOBU_LIGHT

# active window title colors
set-window-option -g  window-status-current-style bg=$BYOBU_HIGHLIGHT
set-window-option -ga window-status-current-style fg=$BYOBU_BRIGHT

# window activity colors
set-window-option -g  window-status-activity-style bg=$BYOBU_DARK
set-window-option -ga window-status-activity-style fg=$BYOBU_LIGHT

# default status bar colors
set-option -g  status-style bg=$BYOBU_DARK
set-option -ga status-style fg=$BYOBU_LIGHT

# message text
set-option -g  message-style bg=$BYOBU_DARK
set-option -ga message-style fg=$BYOBU_LIGHT

