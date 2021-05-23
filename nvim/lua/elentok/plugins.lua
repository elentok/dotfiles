return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Helper functions for writing vimrc in lua.
  use 'svermeulen/vimpeccable'

  -- Color scheme.
  use {'embark-theme/vim', as = 'embark'}

  -- File manager.
  use 'cocopon/vaffle.vim'

  use 'tpope/vim-abolish'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'

  -- Automatically close bracket and tag pairs
  use 'windwp/nvim-autopairs'

  -- Move arguments to the left and right.
  use 'AndrewRadev/sideways.vim'

  -- LSP.
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/completion-nvim'
  use 'anott03/nvim-lspinstall'

end, {
  display = {
    open_fn = require('packer.util').float,
  }
})
