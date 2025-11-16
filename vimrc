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
if has('clipboard')
    set clipboard=unnamedplus,unnamed
endif

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

set background=dark
silent! colorscheme habamax

if has("termguicolors")
    set termguicolors
endif

set cursorline
