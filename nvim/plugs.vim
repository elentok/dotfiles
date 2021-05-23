call plug#begin('~/.local/share/nvim-plugins')

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'elentok/replace-all.vim', { 'on': ['FindAll', 'ReplaceAll'] }
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' } " dark/zen room, no distraction mode
Plug 'schickling/vim-bufonly', { 'on': ['BufOnly', 'Bonly', 'BOnly'] }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind']}
" Plug 'tomtom/tlib_vim'
" Plug 'xolox/vim-misc'
Plug 'fatih/vim-go',                    { 'for': 'go' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" a collection of language packs for vim:
" Plug 'sheerun/vim-polyglot'

if file_readable(expand("~/.dotlocal/nvim/plugs.vim"))
  source ~/.dotlocal/nvim/plugs.vim
endif

call plug#end()
