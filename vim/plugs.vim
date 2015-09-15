" init vundle
set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Arduino-syntax-file'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'Raimondi/delimitMate'
Plug 'applescript.vim'
Plug 'asymmetric/upstart.vim'
Plug 'avakhov/vim-yaml'
Plug 'benmills/vimux'
Plug 'bling/vim-airline'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'digitaltoad/vim-jade'
Plug 'elentok/alternate-spec.vim'
Plug 'elentok/ctrlp-objects.vim'
Plug 'elentok/markdown-preview.vim'
Plug 'elentok/notes.vim'
Plug 'elentok/plaintasks.vim'
Plug 'elentok/replace-all.vim'
Plug 'elentok/run.vim'
Plug 'elentok/spec-runner.vim'
Plug 'elentok/todo.vim'
Plug 'elentok/togglr.vim'
Plug 'elentok/vim-markdown-folding'
Plug 'elentok/vim-rails-extra'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'fatih/vim-go'
Plug 'groenewege/vim-less'
Plug 'iandoe/vim-osx-colorpicker'
Plug 'itchyny/calendar.vim'
Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'jplaut/vim-arduino-ino'
Plug 'jtratner/vim-flavored-markdown'
Plug 'junegunn/goyo.vim' " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'jwhitley/vim-matchit'
Plug 'kchmck/vim-coffee-script'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mileszs/ack.vim'
Plug 'mtscout6/vim-cjsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ngmy/vim-rubocop'
Plug 'pangloss/vim-javascript'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
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
Plug 'vim-scripts/buffet.vim'
Plug 'wavded/vim-stylus'
Plug 'xolox/vim-misc'
Plug 'yaml.vim'

if has('nvim')
  Plug 'benekastah/neomake'
  Plug 'kassio/neoterm'
  Plug 'Shougo/deoplete.nvim'
else
  Plug 'scrooloose/syntastic'
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
