return {
  "neovim/nvim-lspconfig",
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      hint_enable = false,
    },
  },
  "onsails/lspkind-nvim",
  {
    "j-hui/fidget.nvim", -- Shows LSP init progress
    version = "*",
    opts = {},
  },
}
