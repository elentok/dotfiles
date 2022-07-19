-- vim: foldmethod=marker
local create_cmd = vim.api.nvim_create_user_command
local config = require("elentok/config")

local lsp = require("elentok/lsp")

-- local withSnippetSupport = vim.lsp.protocol.make_client_capabilities()
-- withSnippetSupport.textDocument.completion.completionItem.snippetSupport = true

lsp.setup({
  pyright = true,
  bashls = true,
  vimls = true,
  yamlls = true,
  jsonls = true,
  html = true,
  cssls = true,
  openscad_ls = true,
  rust_analyzer = true,
})

-- Simple LSPs {{{1
-- lspconfig["pyright"].setup {}
-- lspconfig.bashls.setup {}
-- lspconfig.vimls.setup {}
-- lspconfig.yamlls.setup {}
-- lspconfig.jsonls.setup {}

if config.enable_tsserver then
  lsp.setup({
    tsserver = {
      on_attach = function(client)
        -- Disable tsserver formatting (using prettier instead)
        client.resolved_capabilities.document_formatting = false
      end,
    },
  })
end

local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")
if has_lsp_signature then
  lsp_signature.setup()
end

-- HTML + CSS (Enable snippet support) {{{1
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- lspconfig.html.setup {capabilities = capabilities}
-- lspconfig.cssls.setup {capabilities = capabilities}

-- Keys {{{1
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help)
vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
vim.keymap.set("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end)
vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)

-- Diagnostics:
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setqflist)

-- Toggle diagnostics:
local diagnostic_visible = true
local function toggle_diagnostic()
  if diagnostic_visible then
    vim.diagnostic.hide()
    diagnostic_visible = false
    print("Diagnostics: hidden")
  else
    vim.diagnostic.show()
    diagnostic_visible = true
    print("Diagnostics: visible")
  end
end

vim.keymap.set("n", "<Leader>te", toggle_diagnostic)

-- Add a border to hover windows {{{1
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Use a sharp border with `FloatBorder` highlights
  border = "single",
})

-- Helper commands {{{1
create_cmd("LspLog", ":tabe " .. vim.lsp.get_log_path(), {})
create_cmd("LspDebugOn", function()
  vim.lsp.set_log_level(1)
end, {})
create_cmd("LspDebugOff", function()
  vim.lsp.set_log_level(3)
end, {})
