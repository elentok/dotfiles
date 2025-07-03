return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
    opts = {},
  },

  opts = {
    ensure_installed = {
      "bash-language-server",
      "biome",
      "css-lsp",
      "dprint",
      "eslint_d",
      "fish-lsp",
      "gopls",
      "harper-ls",
      "json-lsp",
      "lua-language-server",
      "marksman",
      "openscad-lsp",
      "prettierd",
      "pyright",
      "rust-analyzer",
      "stylua",
      "taplo",
      "html-lsp",
      "vtsls",
      "yaml-language-server",
    },
  },
}
