return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })

  use({
    "VonHeikemen/lsp-zero.nvim",
    requires = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      -- Snippets
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
  })

  use({
    "tamago324/lir.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" },
    },
  })

  use("jose-elias-alvarez/null-ls.nvim")

  use("rmehri01/onenord.nvim")
  use("mbbill/undotree")
  use({
    "aserowy/tmux.nvim",
    config = function()
      return require("tmux").setup()
    end,
  })
end)
