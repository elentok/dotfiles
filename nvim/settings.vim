" vim: foldmethod=marker

" General {{{1

syntax enable

let mapleader = ','

behave mswin
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set textwidth=80
set colorcolumn=+0
set completeopt=menuone,noinsert,noselect
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
set previewheight=20
set ruler                      " enable ruler
set scrolloff=3
set shiftwidth=2
set showbreak=>>
set showcmd     " show the number of selected lines in the command bar
set softtabstop=2
set suffixesadd+=.rb,.js,.coffee,.js.coffee
set switchbuf=useopen
set tabstop=2
set undolevels=1000
set visualbell
set whichwrap=<,>,[,]
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj
set wildmenu
set wildmode=list:longest,full
set winwidth=84                " makes sure the active window will always be at least 80 characters

set titlestring=0\ %t%(\ %M%)%(\ (%{expand(\ " %:~:.:h\")})%)%(\ %a%)

if exists('+breakindent')
  set breakindent                " https://retracile.net/wiki/VimBreakIndent
end

if !has('nvim')
  set ttyfast
  set t_vb=
end

if has('cryptv')
  set cryptmethod=blowfish
endif


if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif

let g:netrw_localrmdir='rm -r'

" Neovim specific {{{1
if has("nvim")
  set inccommand=nosplit
endif

" Colors {{{1
if !exists("g:elentok_colors_initialized")
  call confirm('aAAAA')
  if (has("termguicolors"))
    set termguicolors
  endif

  let g:one_allow_italics = 1
  colorscheme one
  set background=dark
  " call one#highlight('Normal', '', '1a1a1a', '')
  call one#highlight('Folded', '555555', '111111', '')
  call one#highlight('VertSplit', '', '5c6370', 'none')
  hi TabLine gui=none

  let g:elentok_colors_initialized = 1
endif

" Search {{{1
set incsearch   " incremental search
set ignorecase  " ignore case when search
set smartcase   " ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch    " highlight search terms
set wrapscan    " wrap around when searching

" Highlight Current Line (disabled) {{{1
"set cursorline
"highlight CursorLine guibg=black cterm=none term=none ctermbg=black

" Backup {{{1
set backup writebackup
set backupdir=$HOME/.local/share/vim-backup
set dir=$HOME/.local/share/vim-swap

if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
end

if !isdirectory(&dir)
  call mkdir(&dir, "p")
end

" store undo history even after closing a file
" (disabled because it's annoying)
" set undofile undodir=$temp_dir

" Folding {{{1
set foldtext=getline(v:foldstart)
let php_folding=1
let g:xml_syntax_folding=1

" Unicode {{{1
" With the following settings Vim's UTF-8 behaves as follows:
" - new files with no nonascii chars (>1byte) will be saved as ANSI (no BOM)
" - new files with nonascii chars will be saved as UTF-8 (with BOM)
if &encoding != 'utf-8'
  set encoding=utf-8
endif
" create Unicode files with B.O.M. by default
"setglobal fileencoding=utf-8 bomb
setglobal fileencoding=utf-8
" define the heuristics to recognize file encodings
setglobal fileencodings=ucs-bom,utf-8,default

" Indent Guides {{{1

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey


" Reduce timeout after <ESC> is received. {{{1
set ttimeout
set ttimeoutlen=20
set notimeout

" Insert mode cursor (mac-only) {{{1
" this trick messes up linux terminals
if g:os == "mac"
  let s:xterm_underline = "\<Esc>[4 q"
  let s:xterm_line = "\<Esc>[6 q"
  let s:xterm_block = "\<Esc>[2 q"
  let &t_SI .= s:xterm_line   " Blinking bar cursor when in insert mode
  let &t_EI .= s:xterm_block  " Solid block cursor when in normal mode]]"
endif

" Statusline {{{1
set statusline=
set statusline+=%f " Path to the file in the buffer, as typed or relative to current directory
set statusline+=%< " Where to truncate line
set statusline+=%{&modified?'\ +':''}
set statusline+=%{&readonly?'\ ':''}
set statusline+=%= " Separation point between left and right aligned items
set statusline+=\ [%{''!=#&filetype?&filetype:'none'}]
set statusline+=\ %l:%v " Line number + column number

" Plugin: w0rp/ale (live linting) {{{1
let g:ale_linters = {
      \ 'go': ['gofmt', 'go vet', 'gometalinter'],
      \ 'html': ['htmlhint'],
      \ 'scss': ['sasslint'],
      \ 'typescript': ['tslint', 'tsserver', 'typecheck'],
      \}

let g:ale_go_gometalinter_options = "--disable=golint"

let g:ale_sign_error = '✖'
let g:ale_sign_warning = '?'
hi link ALEErrorSign Error
hi link ALEWarningSign Error

nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

" Plugin: ryanoasis/vim-devicons {{{1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0

" better folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderPatternMatching = 0
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ' '
let g:DevIconsDefaultFolderOpenSymbol = ' '

" Plugin: pangloss/vim-javascript {{{1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" Plugin: airblade/vim-gitgutter {{{1
let g:gitgutter_eager = 0

" Plugin: jtratner/vim-flavored-markdown {{{1
let g:markdown_fold_style = 'nested'

" Plugin: Shougo/deoplete.nvim {{{1
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#case_insensitive = 1
let g:deoplete#sources#ternjs#include_keywords = 1

" Plugin: junegunn/vim-easy-align {{{1
let g:easy_align_delimiters = {
      \ '"': { 'pattern': '"', 'ignore_groups': ['String'] },
      \ '>': { 'pattern': '>>\|->\|=>\|>' },
      \ '/': { 'pattern': '//\+\|/\*\|\*/', 'ignore_groups': ['String'] },
      \ '#': { 'pattern': '#\+', 'ignore_groups': ['String'], 'delimiter_align': 'l' },
      \ ']': {
      \     'pattern':       '[[\]]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ ')': {
      \     'pattern':       '[()]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ 'd': {
      \     'pattern': ' \(\S\+\s*[;=]\)\@=',
      \     'left_margin': 0,
      \     'right_margin': 0
      \   },
      \ '\': { 'pattern': '[\\]', 'ignore_groups': [] }
      \ }

" Plugin: scrooloose/nerdtree {{{1
let NERDTreeIgnore=['\.zeus\.sock$', '\~$']
let NERDTreeHijackNetrw = 0

" Plugin: scrooloose/nerdcommenter {{{1
let g:NERDCustomDelimiters = {
    \ 'scss': { 'left': '//' }
\ }

let g:NERDSpaceDelims = 1

" Plugin: fatih/vim-go {{{1
let g:go_fmt_command = "goimports"

" Plugin: SirVer/ultisnips {{{1
let g:UltiSnipsExpandTrigger="<c-j>"

" Plugin: mhinz/vim-grepper {{{1
let g:grepper = {
  \ 'tools':  ['ag'],
  \ 'open':   1,
  \ 'switch': 0,
  \ 'jump':   1
\ }

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)


" Temp (stuff I'm not sure about) {{{1
let loaded_matchparen=1 " do not show highlight matching parenthesis automatically
