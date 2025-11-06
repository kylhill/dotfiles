set nowrap
set clipboard+=unnamedplus

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

set showmatch
set hlsearch
set ignorecase
set smartcase

set noshowmode      " don't show current mode in bottom bar, Airline handles this
set scrolloff=3
set background=dark

if $TERM =~# '-256color$'
    if has("termguicolors")
        " RGB colors:
        set termguicolors
        silent! colorscheme solarized8
        let g:airline_powerline_fonts=1
    else
        " 256 colors:
        silent! colorscheme solarized
    endif

    let g:solarized_termtrans=1
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='dark'

    set cursorline
    set number
else
    " 16 colors:
    colorscheme habamax
endif

" Jump to the last file position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" NERDTree Configuration
" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1
