call plug#begin('~/.local/share/nvim-plugins')

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'elentok/replace-all.vim', { 'on': ['FindAll', 'ReplaceAll'] }
Plug 'elentok/run.vim'
Plug 'elentok/togglr.vim'
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
Plug 'iandoe/vim-osx-colorpicker'
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'junegunn/vim-easy-align'
Plug 'mhinz/vim-signify'
Plug 'mhinz/vim-grepper'
Plug 'michaeljsmith/vim-indent-object'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-visual-star-search'
Plug 'roxma/vim-tmux-clipboard'
Plug 'schickling/vim-bufonly', { 'on': ['BufOnly', 'Bonly', 'BOnly'] }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind']}
Plug 'tomtom/tlib_vim'
Plug 'xolox/vim-misc'
Plug 'KabbAmine/vCoolor.vim'
Plug 'davidbeckingsale/writegood.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bogado/file-line'
Plug 'janko/vim-test'
Plug 'fatih/vim-go',                    { 'for': 'go' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'voldikss/vim-floaterm'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" a collection of language packs for vim:
" Plug 'sheerun/vim-polyglot'

if file_readable(expand("~/.dotlocal/nvim/plugs.vim"))
  source ~/.dotlocal/nvim/plugs.vim
endif

call plug#end()
