" init vundle
set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Arduino-syntax-file'
Plug 'Konfekt/FastFold'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Raimondi/delimitMate'
Plug 'applescript.vim'
Plug 'asymmetric/upstart.vim'
Plug 'avakhov/vim-yaml' " indentation
Plug 'benmills/vimux'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'digitaltoad/vim-jade'
Plug 'elentok/alternate-spec.vim'
Plug 'elentok/ctrlp-objects.vim'
Plug 'elentok/notes.vim'
Plug 'elentok/replace-all.vim', { 'on': ['FindAll', 'ReplaceAll'] }
Plug 'elentok/run.vim'
Plug 'elentok/spec-runner.vim'
Plug 'elentok/todo.vim'
Plug 'elentok/togglr.vim'
Plug 'elentok/vim-markdown-folding'
Plug 'elentok/vim-rails-extra'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'groenewege/vim-less'
Plug 'iandoe/vim-osx-colorpicker'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'jasoncodes/ctrlp-modified.vim', { 'on': 'CtrlPModified' }
Plug 'jplaut/vim-arduino-ino'
Plug 'jtratner/vim-flavored-markdown' " add on to tpope's markdown plugin (git flavored markdown)
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'kchmck/vim-coffee-script'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mtscout6/vim-cjsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ngmy/vim-rubocop'
Plug 'othree/yajs.vim'
Plug 'pangloss/vim-javascript'
Plug 'schickling/vim-bufonly', { 'on': ['BufOnly', 'Bonly', 'BOnly'] }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': [ 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'shime/vim-livedown', { 'on': 'LivedownPreview' }
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby'
Plug 'xolox/vim-misc'
Plug 'yaml.vim' " syntax highlighting

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
