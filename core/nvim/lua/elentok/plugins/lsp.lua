return {
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason.nvim",
    version = "*",
    build = ":MasonUpdate",
    opts = {

      ui = {
        border = "rounded",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "*",
    opts = { automatic_installation = true },
  },
  { "ray-x/lsp_signature.nvim", opts = {} },
  "onsails/lspkind-nvim",
  "SmiteshP/nvim-navic",
  {
    "folke/trouble.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble" },
  },
  {
    "j-hui/fidget.nvim", -- Shows LSP init progress
    tag = "legacy",
    opts = {},
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  -- Improve neovim lua development (better completion, help, etc...)
  "folke/neodev.nvim",

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      theme = "catppuccin",
    },
  },
}
