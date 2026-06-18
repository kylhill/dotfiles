# dotfiles

Personal Linux configuration managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Requirements

- Bash
- Git
- Python 3, used by Dotbot
- Optional tools configured here: Neovim, Vim, tmux, GnuPG, Docker, and Ansible

## Install

Clone the repository with submodules, then run the installer:

```bash
git clone --recurse-submodules <repository-url> ~/.dotfiles
~/.dotfiles/install
```

The installer initializes missing submodules and links the managed files into the
home directory. Existing destinations are force-replaced by Dotbot. Back up any
configuration that should be retained before running it on a new machine.
Start a new shell afterward, or run `source ~/.bashrc` in an existing Bash session.

The main managed paths are:

- `~/.bashrc`, `~/.inputrc`, and `~/.dircolors`
- `~/.gitconfig`
- `~/.config/nvim` and `~/.vimrc`
- `~/.tmux.conf`
- `~/.ssh/config` and `~/.ssh/config.d/90-linux.conf`
- `~/.local/bin`

SSH directories and repository sources are assigned restrictive permissions at
the end of installation. External submodules retain their upstream modes.

## Git Signing

The signing key is configured, but commits and tags are not signed automatically.
Sign explicitly on machines where the private key is available:

```bash
git commit -S
git tag -s <tag>
```

Per-repository automatic signing can be enabled with:

```bash
git config commit.gpgSign true
git config tag.gpgSign true
```

## Updates

Update the repository and pinned submodules normally:

```bash
git pull --ff-only
git submodule update --init --recursive
~/.dotfiles/install
```

Neovim plugins are managed by lazy.nvim and pinned in `nvim/lazy-lock.json`.
tmux plugins are managed by TPM; starting tmux bootstraps TPM when it is missing.

`do-updates.sh` runs the update-tagged tasks from the Ansible repository in
`~/infra` by default:

```bash
do-updates.sh [--limit HOSTS] [--tags TAGS] [--diff]
```

Override `INFRA_DIR`, `PLAYBOOK`, `TAGS`, `LIMIT`, or `DIFF` through the
environment when needed.
