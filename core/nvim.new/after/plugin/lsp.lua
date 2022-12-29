local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "marksman",
  "sumneko_lua",
})

lsp.nvim_workspace()

lsp.setup()

local grp_id = vim.api.nvim_create_augroup("ElentokLsp", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = grp_id,
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})
