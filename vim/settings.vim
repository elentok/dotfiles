" vim: foldmethod=marker

syntax enable

" Plugin specific {{{1
let NERDTreeIgnore=['\.zeus\.sock$', '\~$']
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"
let g:VimuxUseNearestPane = 1

let g:user_spec_runners = {
  \ 'ruby': { 'command': 'sp {file}' },
  \ 'java': { 'command': 'make test' }
  \}

let g:run_with_vimux=1

let g:ctrlp_dotfiles = 0
"let g:ctrlp_root_markers = ['Gemfile', 'package.json', '.git']
let g:ctrlp_root_markers = ['.git']
let g:ctrlp_switch_buffer = 0
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](tmp|site-packages|node_modules|components)$',
  \ }

" Colors {{{1
set background=dark
if has('gui_running')
  color ir_black
  hi Normal guibg=#121212
else
  " enable 256 colors in the terminal
  set t_Co=256
  color Monokai
  
  hi Normal ctermbg=None
  hi Folded ctermbg=233
  hi NonText ctermbg=None
  hi Folded cterm=bold
  hi Special ctermfg=lightblue
endif


" Go language (disabled) {{{1
"set rtp+=$GOROOT/misc/vim
"set rtp+=/usr/local/Cellar/go/1.0.3/misc/vim
"Bundle 'nsf/gocode', {'rtp': 'vim/'}
"

" General {{{1
behave mswin
set guioptions=gt " use 'e' for gui tabs
set number            " show line numbers
set mouse=a
set scrolloff=3
set iskeyword=@,48-57,_,192-255,$,#,-
set switchbuf=useopen
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif

" makes sure the active window will always be at least 80 characters
set winwidth=84

set undolevels=1000
set history=300       " remember 300 commands
set visualbell t_vb=


" Wild mode {{{1
set wildmenu
set wildmode=full
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o,*.obj

" Formatting {{{1
set formatoptions=qro
"set fillchars=vert:\|,fold:-
set fillchars=
set tabstop=2
set softtabstop=2
set shiftwidth=2
let loaded_matchparen=1 " do not show highlight matching parenthesis automatically
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set whichwrap=<,>,[,]
set expandtab
set nowrap
set linebreak
set showbreak=>>

" Rulers {{{1
set ruler             " enable ruler
set laststatus=2      " always show the statusline
set titlestring=0\ %t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" Search {{{1
set incsearch   " incremental search
set ignorecase  " ignore case when search
set smartcase   " ignore case if search pattern is all lowercase, case-sensitive otherwise
set hlsearch    " highlight search terms

" Highlight Current Line (disabled) {{{1
"set cursorline
"highlight CursorLine guibg=black cterm=none term=none ctermbg=black

" Backup {{{1
set backup writebackup
set backupdir=$temp_dir
set dir=$temp_dir

" Folding {{{1
set foldtext=getline(v:foldstart)
let php_folding=1
let g:xml_syntax_folding=1

" Ruby {{{1
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_include_object = 1
let g:rubycomplete_include_objectspace = 1

" Unicode: {{{1
" With the following settings Vim's UTF-8 behaves as follows:
" - new files with no nonascii chars (>1byte) will be saved as ANSI (no BOM)
" - new files with nonascii chars will be saved as UTF-8 (with BOM)
set encoding=utf-8
" create Unicode files with B.O.M. by default
"setglobal fileencoding=utf-8 bomb
setglobal fileencoding=utf-8
" define the heuristics to recognize file encodings
setglobal fileencodings=ucs-bom,utf-8,default

" Indent Guides {{{1

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

