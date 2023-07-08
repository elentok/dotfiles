require("mason").setup({
  ui = {
    border = "rounded",
  },
})

require("mason-lspconfig").setup({
  automatic_installation = true,
})

-- require("lsp_signature").setup()
require("trouble").setup()
