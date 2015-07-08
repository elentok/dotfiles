" init vundle
set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

" vundles
Plug 'elentok/run.vim'
Plug 'elentok/plaintasks.vim'
Plug 'elentok/notes.vim'
Plug 'elentok/alternate-spec.vim'
Plug 'elentok/supertagger'
Plug 'elentok/spec-runner.vim'
Plug 'elentok/todo.vim'
Plug 'elentok/togglr.vim'
Plug 'elentok/replace-all.vim'
Plug 'elentok/markdown-preview.vim'

" navigation
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jwhitley/vim-matchit'
Plug 'nelstrom/vim-visual-star-search'

Plug 'christoomey/vim-tmux-navigator'

Plug 'vim-scripts/buffet.vim'

" editing

Plug 'jasoncodes/ctrlp-modified.vim'
Plug 'elentok/ctrlp-objects.vim'
Plug 'benmills/vimux'
"Plug 'Lokaltog/powerline', { 'rtp': 'powerline/bindings/vim' }
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'danro/rename.vim'
Plug 'junegunn/vim-easy-align'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'

Plug 'elentok/vim-rails-extra'
Plug 'scrooloose/syntastic'
Plug 'mileszs/ack.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-dispatch'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'iandoe/vim-osx-colorpicker'
Plug 'xolox/vim-misc'
Plug 'ngmy/vim-rubocop'

Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'
" dark/zen room, no distraction mode
Plug 'junegunn/goyo.vim'

if has('lua')
  Plug 'Shougo/neocomplete.vim'
endif
"if has('python') && !exists('g:disable_ycm')
  "Plug 'Valloric/YouCompleteMe'
"end

" text objects:
Plug 'michaeljsmith/vim-indent-object'

" file formats
Plug 'tpope/vim-haml'
Plug 'evanmiller/nginx-vim-syntax'
Plug 'applescript.vim'
Plug 'avakhov/vim-yaml'
Plug 'yaml.vim'
Plug 'digitaltoad/vim-jade'
Plug 'wavded/vim-stylus'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript'
Plug 'vim-ruby/vim-ruby'
Plug 'elentok/vim-markdown-folding'
Plug 'jtratner/vim-flavored-markdown'
Plug 'Arduino-syntax-file'
Plug 'jplaut/vim-arduino-ino'
Plug 'tpope/vim-markdown'
Plug 'asymmetric/upstart.vim'
Plug 'mtscout6/vim-cjsx'

" Go language
Plug 'fatih/vim-go'

if file_readable(expand("~/.dotlocal/plugs.vim"))
  source ~/.dotlocal/plugs.vim
endif

filetype plugin indent on
syntax on
call plug#end()
