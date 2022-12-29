return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  use 'rmehri01/onenord.nvim'
  use 'mbbill/undotree'
  use 'aserowy/tmux.nvim'
end)
