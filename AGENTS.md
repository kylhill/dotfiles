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


<!-- headroom:rtk-instructions -->
# RTK (Rust Token Killer) - Token-Optimized Commands

When running shell commands, **always prefix with `rtk`**. This reduces context
usage by 60-90% with zero behavior change. If rtk has no filter for a command,
it passes through unchanged — so it is always safe to use.

## Key Commands
```bash
# Git (59-80% savings)
rtk git status          rtk git diff            rtk git log

# Files & Search (60-75% savings)
rtk ls <path>           rtk read <file>         rtk grep <pattern>
rtk find <pattern>      rtk diff <file>

# Test (90-99% savings) — shows failures only
rtk pytest tests/       rtk cargo test          rtk test <cmd>

# Build & Lint (80-90% savings) — shows errors only
rtk tsc                 rtk lint                rtk cargo build
rtk prettier --check    rtk mypy                rtk ruff check

# Analysis (70-90% savings)
rtk err <cmd>           rtk log <file>          rtk json <file>
rtk summary <cmd>       rtk deps                rtk env

# GitHub (26-87% savings)
rtk gh pr view <n>      rtk gh run list         rtk gh issue list

# Infrastructure (85% savings)
rtk docker ps           rtk kubectl get         rtk docker logs <c>

# Package managers (70-90% savings)
rtk pip list            rtk pnpm install        rtk npm run <script>
```

## Rules
- In command chains, prefix each segment: `rtk git add . && rtk git commit -m "msg"`
- For debugging, use raw command without rtk prefix
- `rtk proxy <cmd>` runs command without filtering but tracks usage
<!-- /headroom:rtk-instructions -->
