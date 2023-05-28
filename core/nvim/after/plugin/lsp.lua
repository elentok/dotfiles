local create_cmd = vim.api.nvim_create_user_command
local config = require("elentok/config")
local lsp = require("lsp-zero").preset({})
local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

require("luasnip.loaders.from_vscode").lazy_load()

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

cmp.setup({
  sources = {
    { name = "path" },
    { name = "nvim_lsp" },
    { name = "buffer",  keyword_length = 3 },
    { name = "luasnip", keyword_length = 2 },
    { name = "rg" },
  },
  mapping = {
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
    ["<Tab>"] = cmp_action.luasnip_supertab(),
    ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

lsp.ensure_installed({
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
  "lua_ls",
  "tailwindcss",
  "terraformls",
  "graphql",
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

-- Prefer to format with prettierd or eslint_d
lsp.configure("tsserver", {
  capabilities = {
    -- Disable tsserver formatting (using prettier/eslint instead)
    document_formatting = false,
  },
})

lsp.configure("openscad_lsp", {
  cmd = { "openscad-lsp", "--stdio", "--fmt-style", "Google" },
  -- Disabling the OpenSCAD LSP's completion because it's very very slow
  on_attach = function(client)
    client.server_capabilities.completionProvider = false
  end,
})

lsp.setup()

vim.diagnostic.config({ virtual_text = true })
require("lsp_signature").setup()

-- vim: foldmethod=marker
-- local config = require("elentok/config")
--
-- local lsp = require("elentok/lib/lsp")

-- local withSnippetSupport = vim.lsp.protocol.make_client_capabilities()
-- withSnippetSupport.textDocument.completion.completionItem.snippetSupport = true

-- lsp.setup({
--   pyright = true,
--   bashls = true,
--   vimls = true,
--   yamlls = true,
--   jsonls = true,
--   html = true,
--   cssls = true,
--   openscad_ls = {
--     cmd = { "openscad-lsp", "--stdio", "--fmt-exe", "Google" },
--   },
--   rust_analyzer = true,
--   marksman = true,
--   sumneko_lua = {
--     settings = {
--       Lua = {
--         runtime = {
--           -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
--           version = "LuaJIT",
--           -- Setup your lua path
--           path = vim.split(package.path, ";"),
--         },
--         diagnostics = {
--           -- Get the language server to recognize the `vim` global
--           globals = { "vim", "use" },
--         },
--         workspace = {
--           -- Make the server aware of Neovim runtime files
--           library = {
--             [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--             [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--           },
--         },
--       },
--     },
--   },
-- })

-- Simple LSPs {{{1
-- lspconfig["pyright"].setup {}
-- lspconfig.bashls.setup {}
-- lspconfig.vimls.setup {}
-- lspconfig.yamlls.setup {}
-- lspconfig.jsonls.setup {}
--
-- if config.enable_tsserver then
--   lsp.setup({
--     tsserver = {
--       on_attach = function(client)
--         -- Disable tsserver formatting (using prettier instead)
--         client.server_capabilities.document_formatting = false
--       end,
--     },
--   })
-- end

-- HTML + CSS (Enable snippet support) {{{1
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- lspconfig.html.setup {capabilities = capabilities}
-- lspconfig.cssls.setup {capabilities = capabilities}

-- Keys {{{1
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition)
-- vim.keymap.set("n", "K", vim.lsp.buf.hover)
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
-- vim.keymap.set("n", "<space>k", vim.lsp.buf.signature_help)
-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
-- vim.keymap.set("n", "<leader>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end)
-- vim.keymap.set("n", "gD", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
--
-- -- Diagnostics:
-- vim.keymap.set("n", "<space>dd", vim.diagnostic.open_float)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
-- vim.keymap.set("n", "<space>dq", vim.diagnostic.setqflist)

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

-- Helper commands {{{1
create_cmd("LspLog", ":tabe " .. vim.lsp.get_log_path(), {})
create_cmd("LspDebugOn", function()
  vim.lsp.set_log_level(1)
end, {})
create_cmd("LspDebugOff", function()
  vim.lsp.set_log_level(3)
end, {})

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
})
