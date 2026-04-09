require("mason").setup({})

require("mason-tool-installer").setup({
  ensure_installed = {
    "bash-language-server",
    "biome",
    "css-lsp",
    "cssmodules-language-server",
    "docker-compose-language-service",
    "dockerfile-language-server",
    "dprint",
    "eslint-lsp",
    -- "eslint_d",
    "fish-lsp",
    "gopls",
    "harper-ls",
    "html-lsp",
    "json-lsp",
    "lua-language-server",
    "marksman",
    "npm-groovy-lint",
    "openscad-lsp",
    "prettierd",
    "pyright",
    "shfmt",
    "rust-analyzer",
    "stylua",
    "taplo",
    "ty",
    "vtsls",
    "yaml-language-server",
  },
})

vim.keymap.set("n", "<leader>om", ":Mason<cr>", { desc = "Open Mason" })
