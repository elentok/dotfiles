-- vim: foldmethod=marker
local config = require("elentok/config")
local map = require("elentok/map")

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
  cssls = true
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
      end
    }
  })
end

require("lsp_signature").setup()

-- HTML + CSS (Enable snippet support) {{{1
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- lspconfig.html.setup {capabilities = capabilities}
-- lspconfig.cssls.setup {capabilities = capabilities}

-- Keys {{{1
map.normal("gD", map.lua("vim.lsp.buf.declaration()"))
map.normal("gd", map.lua("vim.lsp.buf.definition()"))
map.normal("K", map.lua("vim.lsp.buf.hover()"))
map.normal("gi", map.lua("vim.lsp.buf.implementation()"))
map.normal("<space>k", map.lua("vim.lsp.buf.signature_help()"))
map.normal("<leader>wa", map.lua("vim.lsp.buf.add_workspace_folder()"))
map.normal("<leader>wr", map.lua("vim.lsp.buf.remove_workspace_folder()"))
map.normal("<leader>wl",
           map.lua("print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"))
map.normal("gD", map.lua("vim.lsp.buf.type_definition()"))
map.normal("<leader>rn", map.lua("vim.lsp.buf.rename()"))
map.normal("<leader>gr", map.lua("vim.lsp.buf.references()"))

-- Diagnostics:
map.normal("<space>e", map.lua("vim.diagnostic.open_float()"))
map.normal("[d", map.lua("vim.diagnostic.goto_prev()"))
map.normal("]d", map.lua("vim.diagnostic.goto_next()"))
map.normal("<space>q", map.lua("vim.diagnostic.setqflist()"))

-- Add a border to hover windows {{{1
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      -- Use a sharp border with `FloatBorder` highlights
      border = "single"
    })

-- Helper commands {{{1
vim.cmd("command! LspLog :tabe " .. vim.lsp.get_log_path())
vim.cmd([[
  command! LspDebugOn :lua vim.lsp.set_log_level(1)
  command! LspDebugOff :lua vim.lsp.set_log_level(3)
]])
