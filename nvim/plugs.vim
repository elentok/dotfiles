set nocompatible " disable vi compatibility
filetype off
filetype plugin indent off

call plug#begin('~/.local/share/nvim-plugins')

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'elentok/alternate-spec.vim'
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
" Plug 'rakr/vim-one'
Plug 'challenger-deep-theme/vim'
Plug 'KabbAmine/vCoolor.vim'
Plug 'davidbeckingsale/writegood.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile' }

" File formats:
Plug 'vim-scripts/applescript.vim',       { 'for': 'applescript' }
Plug 'vim-scripts/Arduino-syntax-file',   { 'for': 'ino' }
Plug 'jplaut/vim-arduino-ino',            { 'for': 'ino' }
Plug 'asymmetric/upstart.vim',            { 'for': 'upstart' }
Plug 'digitaltoad/vim-jade',              { 'for': 'jade', 'commit': '319cba1ee5313e8b50fd912d10dfe40a171f0312' }
Plug 'digitaltoad/vim-pug',               { 'for': 'pug' }
Plug 'elentok/notes.vim',                 { 'for': 'notes' }
Plug 'elentok/todo.vim',                  { 'for': 'todo' }
Plug 'elentok/vim-markdown-folding',      { 'for': 'markdown' }
Plug 'tpope/vim-markdown',                { 'for': 'markdown' }
Plug 'jtratner/vim-flavored-markdown',    { 'for': 'markdown' } " add-on to tpope's markdown plugin (git flavored markdown)
Plug 'chr4/nginx.vim',                    { 'for': 'nginx' }
Plug 'fatih/vim-go',                      { 'for': 'go' }
Plug 'groenewege/vim-less',               { 'for': 'less' }
Plug 'pangloss/vim-javascript',           { 'for': 'javascript' }
Plug 'MaxMEllon/vim-jsx-pretty',          { 'for': 'javascript' }
Plug 'kchmck/vim-coffee-script',          { 'for': 'coffee' }
Plug 'vim-ruby/vim-ruby',                 { 'for': 'ruby' }
Plug 'vim-scripts/yaml.vim',              { 'for': 'yaml' } " syntax highlighting
Plug 'avakhov/vim-yaml',                  { 'for': 'yaml' } " indentation
Plug 'tpope/vim-haml',                    { 'for': 'haml' }
Plug 'leafgarland/typescript-vim',        { 'for': 'typescript' }
Plug 'peitalin/vim-jsx-typescript',       { 'for': 'typescript' }
Plug 'PProvost/vim-ps1'

if file_readable(expand("~/.dotlocal/plugs.vim"))
  source ~/.dotlocal/plugs.vim
endif

filetype plugin indent on
syntax on
call plug#end()
