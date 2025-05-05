return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    opts = {},
  },

  opts = {
    ensure_installed = {
      "bash-language-server",
      "eslint_d",
      "harper-ls",
      "json-lsp",
      "lua-language-server",
      "marksman",
      "openscad-lsp",
      "prettierd",
      "stylua",
      "vtsls",
      "yaml-language-server",
      "gopls",
    },
  },
}
