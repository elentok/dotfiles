" init vundle
set nocompatible " disable vi compatibility
filetype off
"let &rtp .= ',' . $vimfiles . "/bundle/vundle"
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'sickill/vim-monokai'

" vundles
Bundle 'elentok/run.vim'
Bundle 'elentok/plaintasks.vim'
Bundle 'elentok/alternate-spec.vim'
Bundle 'elentok/supertagger'
Bundle 'elentok/spec-runner.vim'
Bundle 'elentok/todo.vim'
Bundle 'elentok/togglr.vim'
Bundle 'elentok/replace-all.vim'

" navigation
Bundle 'kien/ctrlp.vim'
Bundle 'jwhitley/vim-matchit'
Bundle "nelstrom/vim-visual-star-search"

" editing

Bundle 'jasoncodes/ctrlp-modified.vim'
Bundle 'elentok/ctrlp-objects.vim'
Bundle 'benmills/vimux'
Bundle 'Lokaltog/powerline', { 'rtp': 'powerline/bindings/vim' }
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-surround'
"Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-unimpaired'
Bundle 'danro/rename.vim'
Bundle 'junegunn/vim-easy-align'
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"

Bundle 'elentok/vim-rails-extra'
Bundle 'scrooloose/syntastic.git'
Bundle 'mileszs/ack.vim'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'Raimondi/delimitMate'
Bundle 'tpope/vim-dispatch'
Bundle 'AndrewRadev/splitjoin.vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-repeat'
Bundle 'iandoe/vim-osx-colorpicker'
Bundle 'xolox/vim-misc'

if version >= 703
  Bundle 'xolox/vim-session'
end

if !exists('g:disable_ycm')
  Bundle 'Valloric/YouCompleteMe'
end
"Bundle 'airblade/vim-gitgutter'

" text objects:
Bundle 'michaeljsmith/vim-indent-object'

" file formats
Bundle 'tpope/vim-haml'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'suan/vim-instant-markdown'
Bundle 'applescript.vim'
Bundle 'avakhov/vim-yaml'
Bundle 'yaml.vim'
Bundle 'digitaltoad/vim-jade'
Bundle 'wavded/vim-stylus'
Bundle 'groenewege/vim-less'
Bundle 'kchmck/vim-coffee-script'
Bundle 'pangloss/vim-javascript'
Bundle 'vim-ruby/vim-ruby'
Bundle 'elentok/vim-markdown-folding'
Bundle 'jtratner/vim-flavored-markdown.git'
"Bundle 'vim-scripts/fish-syntax'

" Go language
Bundle 'nsf/gocode', { 'rtp': 'vim/' }


set runtimepath+=$GOROOT/misc/vim

if file_readable(expand("~/.dotlocal/vundles.vim"))
  source ~/.dotlocal/vundles.vim
endif

filetype plugin indent on
