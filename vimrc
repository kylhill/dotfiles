" Simple Vim defaults for interactive use across local, remote, and TTY sessions.

if filereadable(expand("$VIMRUNTIME/defaults.vim"))
    unlet! skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
else
    set nocompatible
    filetype plugin indent on
    syntax enable
endif

set nomodeline
set autoread
augroup dotfiles_checktime
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END

set hidden
set nowrap
set cursorline
set history=10000

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

set showmatch
set hlsearch
set ignorecase
set smartcase

set splitbelow
set splitright
set scrolloff=3

set background=dark

if exists("&termguicolors")
    if has("gui_running") || $COLORTERM =~? 'truecolor\|24bit'
        set termguicolors
    else
        set notermguicolors
    endif
endif

colorscheme default
if $TERM !=# 'linux' && &t_Co >= 256
    silent! colorscheme habamax
endif
set background=dark
syntax enable
