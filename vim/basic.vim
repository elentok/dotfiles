" This is a basic vim configuration file (for servers)
" vim: foldmethod=marker

" Settings {{{1
set nocompatible
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set colorcolumn=80
set completeopt=menuone
set expandtab
set fillchars=                 " set fillchars=vert:\|,fold:-
set formatoptions=qroc         " see ':help fo-table' for more info
set guioptions=gt              " use 'e' for gui tabs
set history=300                " remember 300 commands
set iskeyword=@,48-57,_,192-255,$,#,-
set laststatus=2               " always show the statusline
set lazyredraw
set linebreak
set list
set listchars=tab:»·,trail:·
set mouse=a
set nowrap
set number                     " show line numbers
set ruler                      " enable ruler
set scrolloff=3
set shiftwidth=2
set showbreak=>>
set showcmd     " show the number of selected lines in the command bar
set softtabstop=2
set switchbuf=useopen
set tabstop=2
set undolevels=1000
set visualbell
set whichwrap=<,>,[,]
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj
set wildmenu
set wildmode=list:longest,full
set winwidth=84                " makes sure the active window will always be at least 80 characters

set incsearch   " incremental search
set ignorecase  " ignore case when search
set smartcase   " ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch    " highlight search terms
set wrapscan    " wrap around when searching

set foldtext=getline(v:foldstart)

" Reduce timeout after <ESC> is received.
set ttimeout
set ttimeoutlen=20
set notimeout

syntax on

" Mappings {{{1
inoremap jk <esc>
nnoremap <cr> :nohls<cr><cr>
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
