" Kyle's custom vimrc

" General Settings
set hidden          " hide buffers when they are abandoned
set autowrite       " automatically save before certain commands
set autochdir       " automatically set current directory to directory of last opened file
set lazyredraw      " do not redraw while executing macros or commands that aren't typed
set nowrap          " don't wrap lines

if has("autocmd")
    " Jump to the last file position when reopening a file
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" UI Configuration
if $TERM =~# '-256color$'
    if has("termguicolors") && has('nvim')
        set termguicolors
        silent! colorscheme solarized8
    else
        silent! colorscheme solarized
    endif

    let g:solarized_termtrans=1
    let g:airline_theme='solarized'
    let g:airline_solarized_bg='dark'

    set background=dark
    set cursorline
else
    set nocursorline
endif

if has('nvim')
    set noshowmode      " don't show current mode in bottom bar, Airline handles this
else
    set showmode        " show mode in the bottom bar
endif

set showmatch           " highlight matching brackets
set mouse=              " disable mouse

" Spaces and Tabs
set expandtab           " tabs are spaces
set shiftwidth=4        " number of spaces per level of indentation
set softtabstop=4       " number of spaces per tab

" Searching
set hlsearch            " highlight matches
set ignorecase          " do case insensitive matching
set smartcase           " do smart case matching

" Backups and Swap
set writebackup
set nobackup
set noundofile

" NERDTree Configuration
if has("autocmd")
    " Start NERDTree when Vim starts with a directory argument.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
endif

map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let NERDTreeAutoDeleteBuffer=1
