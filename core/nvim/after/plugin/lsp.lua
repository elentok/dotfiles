local config = require("elentok/config")
local lspconfig = require("lspconfig")
local create_cmd = vim.api.nvim_create_user_command

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

require("lsp_signature").setup()
require("neodev").setup()

-- add border to hover floats (when pressing K)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
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

-- LSP setup

local lua_runtime_path = vim.split(package.path, ";")
table.insert(lua_runtime_path, "lua/?.lua")
table.insert(lua_runtime_path, "lua/?/init.lua")
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = lua_runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.stdpath("config") .. "/lua",
        },
      },
    },
  },
})

lspconfig.openscad_lsp.setup({
  cmd = { "openscad-lsp", "--stdio", "--fmt-style", "Google" },
  -- Disabling the OpenSCAD LSP's completion because it's very very slow
  on_attach = function(client)
    client.server_capabilities.completionProvider = false
  end,
})

if config.enable_tsserver then
  lspconfig.tsserver.setup({
    on_attach = function(client)
      -- Disable tsserver formatting (using prettier instead)
      client.server_capabilities.document_formatting = false
    end,
  })
end
--
-- lsp.setup()

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

-- Helper commands {{{1
create_cmd("LspLog", ":tabe " .. vim.lsp.get_log_path(), {})
create_cmd("LspDebugOn", function()
  vim.lsp.set_log_level(1)
end, {})
create_cmd("LspDebugOff", function()
  vim.lsp.set_log_level(3)
end, {})
