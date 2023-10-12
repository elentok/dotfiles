return {
  "neovim/nvim-lspconfig",
  { "ray-x/lsp_signature.nvim", opts = {} },
  "onsails/lspkind-nvim",
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
}
