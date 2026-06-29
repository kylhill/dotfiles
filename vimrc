" Vim defaults plus local overrides.
"
" This file is used both as ~/.vimrc and as /etc/vim/vimrc.local.  Source
" defaults.vim here so the local overrides below are layered on top in both
" cases, then prevent Debian's system vimrc from loading defaults.vim again
" after vimrc.local.
if filereadable(expand("$VIMRUNTIME/defaults.vim"))
    unlet! g:skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
    let g:skip_defaults_vim = 1
else
    set nocompatible
    filetype plugin indent on
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
set complete-=i
set display+=lastline
set laststatus=2

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
set sidescroll=1
set sidescrolloff=2
set tabpagemax=50
set sessionoptions-=options
set viewoptions-=options

if exists("&termguicolors")
    if has("gui_running") || $COLORTERM =~? 'truecolor\|24bit'
        set termguicolors
    else
        set notermguicolors
    endif
endif

silent! colorscheme default
if $TERM !=# 'linux' && &t_Co >= 256
    silent! colorscheme catppuccin
    if !exists("g:colors_name") || g:colors_name !=# "catppuccin"
        silent! colorscheme habamax
    endif
endif
set background=dark
silent! syntax enable
