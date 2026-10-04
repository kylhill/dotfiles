# Agent Instructions

These instructions apply to work in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository using [Dotbot](https://github.com/anishathalye/dotbot) for installation. Dotbot is vendored as a git submodule at `external/dotbot`.

## Installation

```bash
./install
```

This runs Dotbot with `install.conf.yaml`, which:
1. Creates `~/.cache` and `~/.ssh` directories
2. Initializes git submodules (`external/dotbot`, `external/dircolors-solarized`)
3. Symlinks all config files to their target locations in `$HOME`

## Architecture

| File/Dir | Symlink target | Purpose |
|---|---|---|
| `bashrc` | `~/.bashrc` | Shell config (standard Bash + Starship + aliases) |
| `bash/docker.bash` | `~/.config/bash/docker.bash` | Docker helpers and completions, loaded when Docker is installed |
| `gitconfig` | `~/.gitconfig` | Git settings (explicit GPG signing) |
| `inputrc` | `~/.inputrc` | Readline config |
| `tmux.conf` | `~/.tmux.conf` | Tmux config |
| `vimrc` | `~/.vimrc` | Vim config |
| `nvim/` | `~/.config/nvim` | Neovim config (LazyVim-based) |
| `ssh/config` | `~/.ssh/config` | SSH client config (mode 0600) |
| `bin/` | `~/.local/bin` | Personal scripts |
| `starship.toml` | `~/.config/starship.toml` | Starship prompt |
| `external/dircolors-solarized/dircolors.256dark` | `~/.dircolors` | LS colors |

## Key Conventions

### Dotbot config (`install.conf.yaml`)
- Do not edit `install`; it is copied from `external/dotbot/tools/git-submodule/install`, with only `DOTBOT_DIR` adjusted for this repository
- `relink: true` and `backup: true` are set globally — conflicting files receive timestamped backups
- SSH file permissions are enforced by the final shell step because `link` does not support `mode`
- Adding a new dotfile: add an entry under the `link:` section mapping `~/.target` to the repo path

### Neovim (`nvim/`)
- Built on [LazyVim](https://www.lazyvim.org/) pinned in `nvim/lazy-lock.json`
- Plugin specs live in `nvim/lua/plugins/` — each file returns a table of lazy.nvim plugin specs
- LazyVim extras are managed via `nvim/lazyvim.json`
- Lua formatting: 2-space indents, 120 column width (enforced by `nvim/stylua.toml`)
- Luarocks support is disabled (`rocks.enabled = false`) to avoid system dependencies

### Shell (`bashrc`)
- Uses standard Bash and bash-completion, with Starship when available
- Bash prompt colors use the system skeleton's capability check (`tput setaf 1`), enabled by default
- All systems use Neovim and alias Vim commands to it when installed; otherwise the editor falls back to Vim/vi
- Shell and tmux prompts use ASCII symbols; do not require Nerd Fonts
- Preserves forwarded SSH agents; local sockets are used only when no agent is set

### Git (`gitconfig`)
- GPG commit and tag signing is explicit by default
- `pull.rebase = true` and `rebase.autoSquash = true`; automatic stashing is intentionally disabled
- `fetch.prune = true` — remote-tracking branches are pruned on fetch

### Scripts (`bin/`)
- All scripts use `set -euo pipefail` with an ERR trap for line-level error reporting
