set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'benmills/vimux'
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
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'leafgarland/typescript-vim'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'ngmy/vim-rubocop'
Plug 'roxma/vim-tmux-clipboard'
Plug 'sbdchd/neoformat'
Plug 'schickling/vim-bufonly', { 'on': ['BufOnly', 'Bonly', 'BOnly'] }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind']}
Plug 'Quramy/tsuquyomi'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'xolox/vim-misc'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets' " snippets for ultisnips

" File formats:
Plug 'vim-scripts/applescript.vim',    { 'for': 'applescript' }
Plug 'vim-scripts/Arduino-syntax-file',{ 'for': 'ino' }
Plug 'jplaut/vim-arduino-ino',         { 'for': 'ino' }
Plug 'asymmetric/upstart.vim',         { 'for': 'upstart' }
Plug 'digitaltoad/vim-jade',           { 'for': 'jade', 'commit': '319cba1ee5313e8b50fd912d10dfe40a171f0312' }
Plug 'digitaltoad/vim-pug',            { 'for': 'pug' }
Plug 'elentok/notes.vim',              { 'for': 'notes' }
Plug 'elentok/todo.vim',               { 'for': 'todo' }
Plug 'elentok/vim-markdown-folding',   { 'for': 'markdown' }
Plug 'tpope/vim-markdown',             { 'for': 'markdown' }
Plug 'jtratner/vim-flavored-markdown', { 'for': 'markdown' } " add-on to tpope's markdown plugin (git flavored markdown)
Plug 'shime/vim-livedown',             { 'for': 'markdown', 'on': 'LivedownPreview' }
Plug 'evanmiller/nginx-vim-syntax',    { 'for': 'nginx' }
Plug 'fatih/vim-go',                   { 'for': 'go' }
Plug 'groenewege/vim-less',            { 'for': 'less' }
Plug 'pangloss/vim-javascript',        { 'for': 'javascript' }
Plug 'mxw/vim-jsx',                    { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script',       { 'for': 'coffee' }
Plug 'vim-ruby/vim-ruby',              { 'for': 'ruby' }
Plug 'vim-scripts/yaml.vim',           { 'for': 'yaml' } " syntax highlighting
Plug 'avakhov/vim-yaml',               { 'for': 'yaml' } " indentation
Plug 'tpope/vim-haml',                 { 'for': 'haml' }

if has('nvim')
  Plug 'w0rp/ale'
  Plug 'kassio/neoterm'

  " Plug 'roxma/nvim-completion-manager',
        " \ { 'do': 'pip3 install --user neovim jedi mistune psutil setproctitle' }
  " Plug 'roxma/nvim-cm-tern'
  " Plug 'roxma/ncm-rct-complete'

  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
  Plug 'Shougo/neco-vim'
else
  Plug 'scrooloose/syntastic'
  Plug 'jwhitley/vim-matchit' " embedded in neovim
  if has('lua')
    Plug 'Shougo/neocomplete.vim'
  endif
endif

if file_readable(expand("~/.dotlocal/plugs.vim"))
  source ~/.dotlocal/plugs.vim
endif

filetype plugin indent on
syntax on
call plug#end()
