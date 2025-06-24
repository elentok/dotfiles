return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    opts = {},
  },

  opts = {
    ensure_installed = {
      "bash-language-server",
      "css-lsp",
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
      "dprint",
      "biome",
      "taplo",
    },
  },
}
