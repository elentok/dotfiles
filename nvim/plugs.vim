call plug#begin('~/.local/share/nvim-plugins')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind']}

" a collection of language packs for vim:
" Plug 'sheerun/vim-polyglot'

if file_readable(expand("~/.dotlocal/nvim/plugs.vim"))
  source ~/.dotlocal/nvim/plugs.vim
endif

call plug#end()
