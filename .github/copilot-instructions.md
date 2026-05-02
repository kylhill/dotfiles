# Copilot Instructions

## Repository Overview

This is a personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation. Dotbot is vendored as a git submodule at `external/dotbot`.

## Installation

```bash
./install
```

This runs Dotbot with `install.conf.yaml`, which:
1. Creates `~/.cache` and `~/.ssh` directories
2. Initializes git submodules (`external/dotbot`, `external/oh-my-bash`, `external/dircolors-solarized`)
3. Symlinks all config files to their target locations in `$HOME`

## Architecture

| File/Dir | Symlink target | Purpose |
|---|---|---|
| `bashrc` | `~/.bashrc` | Shell config (oh-my-bash + aliases) |
| `gitconfig` | `~/.gitconfig` | Git settings (GPG signing enabled) |
| `inputrc` | `~/.inputrc` | Readline config |
| `tmux.conf` | `~/.tmux.conf` | Tmux config |
| `vimrc` | `~/.vimrc` | Vim config |
| `nvim/` | `~/.config/nvim` | Neovim config (LazyVim-based) |
| `ssh/config` | `~/.ssh/config` | SSH client config (mode 0600) |
| `bin/` | `~/.local/bin` | Personal scripts |
| `external/oh-my-bash` | `~/.oh-my-bash` | Oh My Bash framework |
| `external/dircolors-solarized/dircolors.256dark` | `~/.dircolors` | LS colors |

## Key Conventions

### Dotbot config (`install.conf.yaml`)
- `relink: true` and `force: true` are set globally — symlinks are always recreated
- SSH config is linked with explicit `mode: "0600"`
- Adding a new dotfile: add an entry under the `link:` section mapping `~/.target` to the repo path

### Neovim (`nvim/`)
- Built on [LazyVim](https://www.lazyvim.org/) v14 (pinned in `nvim/lua/plugins/core.lua` for Ubuntu compatibility)
- Plugin specs live in `nvim/lua/plugins/` — each file returns a table of lazy.nvim plugin specs
- LazyVim extras are managed via `nvim/lazyvim.json`
- Lua formatting: 2-space indents, 120 column width (enforced by `nvim/stylua.toml`)
- Luarocks support is disabled (`rocks.enabled = false`) to avoid system dependencies

### Shell (`bashrc`)
- Uses oh-my-bash; theme switches between `agnoster` (fancy terminal / SSH / display) and `font` (basic)
- nvim is set as `$EDITOR` only when on a fancy terminal (`$SSH_CONNECTION`, `$DISPLAY`, or `$WAYLAND_DISPLAY` is set); otherwise falls back to vim
- Termux detection skips oh-my-bash and falls back to manual dircolors + bash-completion setup

### Git (`gitconfig`)
- GPG commit and tag signing is enabled by default
- `pull.rebase = true`, `rebase.autostash = true`, `rebase.autoSquash = true`
- `fetch.prune = true` — remote-tracking branches are pruned on fetch

### Scripts (`bin/`)
- All scripts use `set -euo pipefail` with an ERR trap for line-level error reporting
- `do-updates.sh` wraps `ansible-playbook` and expects an infra directory at `$INFRA_DIR` (default: `~/infra`)
