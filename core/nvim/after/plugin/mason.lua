require("mason").setup({
  ui = {
    border = "rounded",
  },
})
require("mason-lspconfig").setup({
  ensure_installed = {
    "tsserver",
    "marksman",
    "lua_ls",
    "bashls",
    -- "denols",
    "pyright",
    "yamlls",
    "jsonls",
    "html",
    "cssls",
    "rust_analyzer",
    "openscad_lsp",
    "svelte",
    -- "tailwindcss",
    "terraformls",
    "graphql",
  },
})
