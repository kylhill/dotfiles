" General Settings
set autochdir       " automatically set current directory to directory of last opened file
set nowrap          " don't wrap lines
set writebackup     " keep a backup file when overwriting a file

" Spaces and Tabs
set expandtab       " tabs are spaces
set shiftwidth=4    " number of spaces per level of indentation
set softtabstop=4   " number of spaces per tab

" UI Configuration
set noshowmode      " don't show current mode in bottom bar, Airline handles this
set showmatch       " highlight matching brackets

if $TERM =~# '-256color$'
    if has("termguicolors")
        set termguicolors
        silent! colorscheme solarized8
    else
        silent! colorscheme solarized
    endif

    let g:solarized_termtrans=1
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='dark'
    let g:airline_powerline_fonts=1

    set cursorline
else
    colorscheme vim
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
