-- Align editor behavior with modules/home/kyleh/neovim.nix.
vim.g.mapleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.lazyvim_picker = "snacks"

local opt = vim.opt
opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.guifont = "CaskaydiaCove Nerd Font Mono:h10"
opt.ignorecase = true
opt.list = false
opt.modeline = false
opt.mouse = "a"
opt.number = true
opt.relativenumber = false
opt.scrolloff = 4
opt.shiftwidth = 4
opt.showmatch = true
opt.sidescroll = 1
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end
opt.softtabstop = -1
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.wrap = false
