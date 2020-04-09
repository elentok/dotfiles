" set nocompatible " disable vi compatibility
" filetype off
" filetype plugin indent off

call plug#begin('~/.local/share/nvim-plugins')

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'elentok/replace-all.vim', { 'on': ['FindAll', 'ReplaceAll'] }
Plug 'elentok/run.vim'
Plug 'elentok/togglr.vim'
Plug 'elentok/vim-rails-extra'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'iandoe/vim-osx-colorpicker'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'roxma/vim-tmux-clipboard'
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
Plug 'KabbAmine/vCoolor.vim'
Plug 'davidbeckingsale/writegood.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'cocopon/vaffle.vim'
Plug 'bogado/file-line'
Plug 'yuki-ycino/fzf-preview.vim'
Plug 'janko/vim-test'
Plug 'fatih/vim-go',                      { 'for': 'go' }

" a collection of language packs for vim:
Plug 'sheerun/vim-polyglot'

" color scheme:
Plug 'danilo-augusto/vim-afterglow'

if has("nvim-0.5")
  Plug 'neovim/nvim-lsp'
else
  " Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  " Plug 'dense-analysis/ale'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
  " Plug 'deoplete-plugins/deoplete-jedi'
  " Plug 'davidhalter/jedi-vim'
  " Plug 'ncm2/float-preview.nvim'
endif

if file_readable(expand("~/.dotlocal/plugs.vim"))
  source ~/.dotlocal/plugs.vim
endif

" filetype plugin indent on
" syntax on
call plug#end()
