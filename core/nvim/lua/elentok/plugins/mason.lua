return {
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
}
