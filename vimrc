" Local Vim overrides, intended to be sourced after system Vim defaults.

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
