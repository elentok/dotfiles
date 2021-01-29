call plug#begin('~/.local/share/nvim-plugins')

if file_readable(expand("~/.dotlocal/nvim/plugs.vim"))
  source ~/.dotlocal/nvim/plugs.vim
endif

call plug#end()
