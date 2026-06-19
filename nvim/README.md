# Neovim Configuration

This is a small [LazyVim](https://www.lazyvim.org/) configuration intended for
terminal Neovim sessions, primarily through tmux and SSH.

## Behavior

- Four spaces are the fallback indentation width. Project EditorConfig files
  can override it, and `softtabstop` follows `shiftwidth`.
- Modelines and the Node.js, Perl, and Ruby providers are disabled.
- Shell files are formatted with shfmt and linted with ShellCheck.
- Markdown-specific LSP, formatting, linting, preview, and rendering plugins
  are disabled.
- `vim-tmux-navigator` loads on `VeryLazy` so navigation works from both Normal
  mode and Neovim terminal buffers. The matching tmux plugin must also be
  installed.
- gzip, tar, and zip runtime handlers remain enabled.

## Dependencies

LazyVim requires Neovim 0.11.2 or newer. The surrounding dotfiles installation
provides Git, ripgrep, fdfind, fzf, lazygit, curl, a C compiler, make, and
ShellCheck.

Mason manages the active Neovim-specific tools:

- lua-language-server
- shfmt
- stylua

The Tree-sitter CLI is supplied externally. Its version is intentionally not
managed or upgraded by this configuration.

## Updates

- `:Lazy update` updates plugins and writes `lazy-lock.json`.
- `:Lazy restore` restores plugin revisions from the lockfile.
- `:Mason` shows the installed external editor tools.

Commit `lazy-lock.json` whenever plugin revisions change.

## Validation

Run these commands from the dotfiles repository root:

```bash
~/.local/share/nvim/mason/bin/stylua --check nvim
python3 -m json.tool nvim/lazyvim.json >/dev/null
python3 -m json.tool nvim/lazy-lock.json >/dev/null
XDG_STATE_HOME="$(mktemp -d)" XDG_CACHE_HOME="$(mktemp -d)" nvim --headless +qa
git diff --check
```
