-- vim: foldmethod=marker
local lspconfig = require("lspconfig")
local config = require("elentok/config")
local map = require("elentok/map")

-- Simple LSPs {{{1
lspconfig.pyright.setup {}
lspconfig.bashls.setup {}
lspconfig.vimls.setup {}
lspconfig.yamlls.setup {}
lspconfig.jsonls.setup {}

if config.enable_tsserver then
  lspconfig.tsserver.setup {
    on_attach = function(client)
      -- Disable tsserver formatting (using prettier instead)
      client.resolved_capabilities.document_formatting = false
    end
  }
end

-- HTML + CSS (Enable snippet support) {{{1
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup {capabilities = capabilities}
lspconfig.cssls.setup {capabilities = capabilities}

-- Lua {{{1
local lua_lsp_root_path = vim.fn.expand(
                              "~/.apps/all/lua-language-server/default")
local lua_lsp_bin_path = lua_lsp_root_path .. "/bin/Linux/lua-language-server"
local lua_lsp_main_lua = lua_lsp_root_path .. "/main.lua"
lspconfig.sumneko_lua.setup {
  cmd = {lua_lsp_bin_path, "-E", lua_lsp_main_lua},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim", "use"}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
    }
  }
}

-- DiagnosticLS {{{1
lspconfig.diagnosticls.setup {
  filetypes = {"sh"},
  init_options = {
    filetypes = {sh = "shellcheck"},
    formatFiletypes = {sh = "shfmt"},
    linters = {
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = {"--format", "json", "-"},
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint"
        }
      }
    },
    formatters = {
      shfmt = {command = "shfmt", args = {"-i", "2", "-bn", "-ci", "-sr"}}
    }
  }
}

-- Keys {{{1
map.normal("gD", map.lua("vim.lsp.buf.declaration()"))
map.normal("gd", map.lua("vim.lsp.buf.definition()"))
-- map.normal("K", map.lua("vim.lsp.buf.hover()"))
map.normal("gi", map.lua("vim.lsp.buf.implementation()"))
map.normal("<space>k", map.lua("vim.lsp.buf.signature_help()"))
map.normal("<leader>wa", map.lua("vim.lsp.buf.add_workspace_folder()"))
map.normal("<leader>wr", map.lua("vim.lsp.buf.remove_workspace_folder()"))
map.normal("<leader>wl",
           map.lua("print(vim.inspect(vim.lsp.buf.list_workspace_folders()))"))
map.normal("gD", map.lua("vim.lsp.buf.type_definition()"))
-- map.normal("<leader>rn", map.lua("vim.lsp.buf.rename()"))
map.normal("gr", map.lua("vim.lsp.buf.references()"))
-- map.normal("<space>e", map.lua("vim.lsp.diagnostic.show_line_diagnostics()"))
-- map.normal("[d", map.lua("vim.lsp.diagnostic.goto_prev()"))
-- map.normal("]d", map.lua("vim.lsp.diagnostic.goto_next()"))
map.normal("<space>q", map.lua("vim.lsp.diagnostic.set_loclist()"))
