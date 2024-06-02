return {
  "neovim/nvim-lspconfig",
  { "ray-x/lsp_signature.nvim", opts = {} },
  "onsails/lspkind-nvim",
  {
    "j-hui/fidget.nvim", -- Shows LSP init progress
    tag = "legacy",
    opts = {},
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  -- },
}
