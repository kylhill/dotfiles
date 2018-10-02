# Set up C-a shortcut
unbind-key -n C-a
set -g prefix ^A
set -g prefix2 ^A
bind a send-prefix

# Move around panes with j and k, a bit like vim
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

bind-key -r C-h select-window -t :-
bind-key -r C-l select-window -t :+

# Resize pane shortcuts
bind -r H resize-pane -L 10
bind -r J resize-pane -D 10
bind -r K resize-pane -U 10
bind -r L resize-pane -R 10

# Copy and paste a bit like vim
unbind [
bind Escape copy-mode
unbind p
bind p paste-buffer
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection

# Smart pane switching with awareness of vim splits
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"'
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
bind -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
bind-key -T copy-mode-vi C-h select-pane -L
bind-key -T copy-mode-vi C-j select-pane -D
bind-key -T copy-mode-vi C-k select-pane -U
bind-key -T copy-mode-vi C-l select-pane -R
bind-key -T copy-mode-vi C-\ select-pane -l
