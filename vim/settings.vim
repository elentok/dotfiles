" vim: foldmethod=marker

syntax enable

let mapleader = ','

behave mswin
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set colorcolumn=80
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

if has("nvim-0.1.7")
  set inccommand=nosplit
endif

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

" Plugin specific {{{1

" pangloss/vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

" fzf
" let g:fzf_prefer_tmux = 1

" matchit
let loaded_matchparen=1 " do not show highlight matching parenthesis automatically
let NERDTreeIgnore=['\.zeus\.sock$', '\~$']
let NERDTreeHijackNetrw = 0
let g:VimuxOrientation = "h"
let g:VimuxHeight = "40"
let g:VimuxUseNearestPane = 1
let g:run_with_vimux=1
let g:user_spec_runners = {
  \ 'ruby': { 'command': 'sp {file}' },
  \ 'java': { 'command': 'make test' }
  \}
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:session_autosave = 'no'
let g:session_autoload = 'no'
let g:gitgutter_eager = 0
let g:instant_markdown_slow = 1
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#auto_completion_start_length = 4
let g:airline_powerline_fonts=1
" let g:airline#extensions#branch#enabled = 0
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_mode_map = { "mode": "active",
                           \ "active_filetypes": [],
                           \ "passive_filetypes": ['sass', 'scss', 'haml', 'html', 'dart']}

let g:markdown_fold_style = 'nested'
let g:deoplete#enable_at_startup = 1

" CtrlP {{{1

" Use Silversearcher to list files (much faster)
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Silversearcher is fast enough, so no need for caching
" let g:ctrlp_use_caching = 0

let g:ctrlp_dotfiles = 0
let g:ctrlp_root_markers = ['.git']
let g:ctrlp_switch_buffer = 0
let g:ctrlp_by_filename = 0
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](tmp|site-packages|node_modules|bower_components)$',
  \ }
let g:ctrlp_buftag_types = {
  \ 'coffee': '',
  \ 'ghmarkdown': '',
  \ 'go': '',
  \ 'javascript': '',
  \ 'markdown': '',
  \ 'scss': ''
  \ }

let g:ctrlp_buffer_func = {
  \ 'enter': 'CtrlP_Enter'}

func! CtrlP_Enter()
  nn <buffer> <f3> :call CtrlP_CloseBuffer()<cr>
endfunc

func! CtrlP_CloseBuffer()
  let buf=fnamemodify(getline('.')[2:], ':p')
  exec 'bd' buf
  call feedkeys("\<f5>")
endfunc


" EasyAlign {{{1

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

" Colors {{{1
set background=dark
if has('gui_running')
  color ir_black
  hi Normal guibg=#121212
else
  " enable 256 colors in the terminal
  set t_Co=256
  let base16colorspace=256
  color base16-elentok
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

" Insert mode cursor {{{1

" this trick messes up linux terminals
if g:os == "mac"
  let s:xterm_underline = "\<Esc>[4 q"
  let s:xterm_line = "\<Esc>[6 q"
  let s:xterm_block = "\<Esc>[2 q"
  let &t_SI .= s:xterm_line   " Blinking bar cursor when in insert mode
  let &t_EI .= s:xterm_block  " Solid block cursor when in normal mode]]"
endif

" Neomake {{{1
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_html_enabled_makers = []
let g:neomake_java_enabled_makers = []
let g:neomake_error_sign = {
    \ 'text': '✖',
    \ 'texthl': 'ErrorMsg',
    \ }
let g:neomake_warning_sign = {
    \ 'text': '⚠',
    \ 'texthl': 'WarningMsg',
    \ }

" NERDCommenter {{{1
let g:NERDCustomDelimiters = {
    \ 'scss': { 'left': '//' }
\ }

let g:NERDSpaceDelims = 1

" Grepper {{{1
let g:grepper = {
  \ 'tools':  ['ag'],
  \ 'open':   1,
  \ 'switch': 0,
  \ 'jump':   1
\ }

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" UltiSnips {{{1
let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsJumpForwardTrigger="<c-b>"
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Go {{{1
let g:go_fmt_command = "goimports"
