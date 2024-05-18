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
    keys = {
      {
        "<leader>om",
        "<Cmd>Mason<cr>",
        desc = "Open mason",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "*",
    opts = { automatic_installation = true },
  },
}
