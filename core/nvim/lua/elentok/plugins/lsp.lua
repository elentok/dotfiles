return {
  "neovim/nvim-lspconfig",
  { "williamboman/mason.nvim",  build = ":MasonUpdate" },
  "williamboman/mason-lspconfig.nvim",
  { "ray-x/lsp_signature.nvim", opts = {} },
  "stevearc/aerial.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "onsails/lspkind-nvim",
  "SmiteshP/nvim-navic",
  { "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
  {
    "folke/trouble.nvim",
    opts = {},
    dependencies = { "kyazdani42/nvim-web-devicons" },
    cmd = { "Trouble" },
  },
  {
    "j-hui/fidget.nvim", -- Shows LSP init progress
    tag = "legacy",
    opts = {},
  },
  -- "jose-elias-alvarez/typescript.nvim",
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  -- Improve neovim lua development (better completion, help, etc...)
  "folke/neodev.nvim",
}
