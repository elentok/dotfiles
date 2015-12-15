" init vundle
set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Konfekt/FastFold'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'elentok/alternate-spec.vim'
Plug 'elentok/replace-all.vim', { 'on': ['FindAll', 'ReplaceAll'] }
Plug 'elentok/run.vim'
Plug 'elentok/spec-runner.vim'
Plug 'elentok/togglr.vim'
Plug 'elentok/vim-rails-extra'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'iandoe/vim-osx-colorpicker'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ngmy/vim-rubocop'
Plug 'schickling/vim-bufonly', { 'on': ['BufOnly', 'Bonly', 'BOnly'] }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind']}
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'xolox/vim-misc'

" File formats:
Plug 'applescript.vim',                { 'for': 'applescript' }
Plug 'Arduino-syntax-file',            { 'for': 'ino' }
Plug 'jplaut/vim-arduino-ino',         { 'for': 'ino' }
Plug 'asymmetric/upstart.vim',         { 'for': 'upstart' }
Plug 'digitaltoad/vim-jade',           { 'for': 'jade' }
Plug 'elentok/notes.vim',              { 'for': 'notes' }
Plug 'elentok/todo.vim',               { 'for': 'todo' }
Plug 'elentok/vim-markdown-folding',   { 'for': 'markdown' }
Plug 'tpope/vim-markdown',             { 'for': 'markdown' }
Plug 'jtratner/vim-flavored-markdown', { 'for': 'markdown' } " add-on to tpope's markdown plugin (git flavored markdown)
Plug 'shime/vim-livedown',             { 'for': 'markdown', 'on': 'LivedownPreview' }
Plug 'evanmiller/nginx-vim-syntax',    { 'for': 'nginx' }
Plug 'fatih/vim-go',                   { 'for': 'go' }
Plug 'groenewege/vim-less',            { 'for': 'less' }
Plug 'othree/yajs.vim',                { 'for': 'javascript' }
Plug 'pangloss/vim-javascript',        { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffee' }
Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }
Plug 'yaml.vim',                       { 'for': 'yaml' } " syntax highlighting
Plug 'avakhov/vim-yaml',               { 'for': 'yaml' } " indentation
Plug 'tpope/vim-haml',                 { 'for': 'haml' }

if has('nvim')
  Plug 'benekastah/neomake'
  Plug 'kassio/neoterm'
  Plug 'Shougo/deoplete.nvim'
else
  Plug 'scrooloose/syntastic'
  Plug 'jwhitley/vim-matchit' " embedded in neovim
endif


if has('lua')
  Plug 'Shougo/neocomplete.vim'
endif

"Plug 'Lokaltog/powerline', { 'rtp': 'powerline/bindings/vim' }

if file_readable(expand("~/.dotlocal/plugs.vim"))
  source ~/.dotlocal/plugs.vim
endif

filetype plugin indent on
syntax on
call plug#end()
