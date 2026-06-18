" Legacy configuration file for vim

" vim-sensible defaults
set nocompatible
set backspace=indent,eol,start
set smarttab
set incsearch
set laststatus=2
set ruler
set wildmenu
set display+=lastline
set autoread
autocmd FocusGained,BufEnter * checktime
set history=10000

" Enable filetype detection, plugins, indentation, and syntax highlighting
filetype plugin indent on
syntax enable

set hidden
set nowrap
set modeline

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

set showmatch
set hlsearch
set ignorecase
set smartcase

set splitbelow
set splitright
set scrolloff=3

" Try to set habamax colorscheme, if available
colorscheme default
silent! colorscheme habamax

" Use richer display settings only when the terminal advertises sufficient color support
if has("gui_running") || exists('$PREFIX') || ($TERM !=# 'dumb' && $TERM !=# 'linux' && (&t_Co >= 256 || $COLORTERM =~? 'truecolor\|24bit'))
    if has("termguicolors")
        set termguicolors
    endif
    set cursorline

    set background=dark
else
    set notermguicolors
    set nocursorline

    set background=light
endif
