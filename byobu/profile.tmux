source $BYOBU_PREFIX/share/byobu/profiles/tmux

# Use 256 color tmux if terminal supports it
if-shell 'test $(tput colors) -ge 256' 'set-option -g default-terminal "tmux-256color"'
if-shell 'test $(tput colors) -lt 256' 'set-option -g default-terminal "tmux"'

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
set-option -g pane-active-border-bg $BYOBU_DARK
#set-option -g pane-active-border-fg $BYOBU_HIGHLIGHT
#set-option -g pane-border-fg $BYOBU_ACCENT
set-option -g pane-border-bg $BYOBU_DARK

# pane number display
#set-option -g display-panes-colour $BYOBU_ACCENT
#set-option -g display-panes-active-colour $BYOBU_HIGHLIGHT

# clock
#set-option -g clock-mode-colour $BYOBU_ACCENT

# window mode
set-option -g mode-bg $BYOBU_DARK
#set-option -g mode-fg $BYOBU_LIGHT


# default window title colors
#set-window-option -g window-status-attr default
#set-window-option -g window-status-bg $BYOBU_DARK
#set-window-option -g window-status-fg $BYOBU_LIGHT

# active window title colors
#set-window-option -g window-status-current-attr reverse
set-window-option -g window-status-current-bg $BYOBU_BRIGHT
set-window-option -g window-status-current-fg $BYOBU_HIGHLIGHT

# window activity colors
#set-window-option -g window-status-activity-bg $BYOBU_DARK
#set-window-option -g window-status-activity-fg $BYOBU_LIGHT
#set-window-option -g window-status-activity-attr bold

# default status bar colors
#set-option -g status-bg $BYOBU_DARK
#set-option -g status-fg $BYOBU_LIGHT

# message text
set-option -g message-bg $BYOBU_DARK
set-option -g message-fg $BYOBU_LIGHT

