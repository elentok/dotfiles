-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Color scheme.
  use {'embark-theme/vim', as = 'embark'}

  use {'cocopon/vaffle.vim'}

  use {'tpope/vim-abolish'}
  use {'tpope/vim-dispatch'}
  use {'tpope/vim-eunuch'}
  use {'tpope/vim-fugitive'}
  use {'tpope/vim-repeat'}
  use {'tpope/vim-surround'}
  use {'tpope/vim-unimpaired'}

end, {
  display = {
    open_fn = require('packer.util').float,
  }
})
