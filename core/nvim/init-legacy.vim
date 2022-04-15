" if !exists('$DOTF')
"   let $DOTF = expand('~/.dotfiles')
" endif

source ~/.config/nvim/functions.vim
source ~/.config/nvim/keys.vim

if file_readable(expand("~/.vimstate"))
  source ~/.vimstate
endif
