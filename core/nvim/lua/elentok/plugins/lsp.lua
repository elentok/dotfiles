return {
  "neovim/nvim-lspconfig",

  -- Shows the function signature while typing
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      hint_enable = false,
    },
  },

  -- Shows LSP init progress
  {
    "j-hui/fidget.nvim",
    version = "*",
    opts = {},
    event = "VeryLazy",
  },
}
