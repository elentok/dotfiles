-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Color scheme.
  use {'embark-theme/vim', as = 'embark'}

end, {
  display = {
    open_fn = require('packer.util').float,
  }
})
