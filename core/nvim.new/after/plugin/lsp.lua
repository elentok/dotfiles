local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.ensure_installed({
  "tsserver",
  "marksman",
  "sumneko_lua",
  "bashls",
  "pyright",
  "yamlls",
  "jsonls",
  "html",
  "cssls",
  "rust_analyzer",
})

lsp.configure("sumneko_lua", {
  settings = {
    Lua = {
      diagnostics = { "vim" },
    },
  },
})

lsp.nvim_workspace()

lsp.setup()

-- Format ----------------------------------------

local function format()
  vim.lsp.buf.format({ timeout_ms = 2000 })
end

local grp_id = vim.api.nvim_create_augroup("ElentokLsp", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  group = grp_id,
  callback = format,
})

vim.api.nvim_create_user_command("Format", format, {})
