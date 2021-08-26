local util = require('elentok/util')
local map = require('elentok/map')

local lspconfig = util.safe_require('lspconfig')
if not lspconfig then
  print('Warning: lspconfig not found, skipping initialization.')
  return
end

function on_attach(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    map.normal("<space>f", map.lua("vim.lsp.buf.formatting()"))
  elseif client.resolved_capabilities.document_range_formatting then
    map.normal("<space>f", map.lua("vim.lsp.buf.range_formatting()"))
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

lspconfig = require 'lspconfig'
lspconfig.pyright.setup {on_attach = on_attach}
lspconfig.tsserver.setup {
  on_attach = function(client)
    -- Disable tsserver formatting (using prettier instead)
    client.resolved_capabilities.document_formatting = false
    on_attach(client)
  end
}
lspconfig.bashls.setup {on_attach = on_attach}
lspconfig.vimls.setup {on_attach = on_attach}
lspconfig.yamlls.setup {on_attach = on_attach}
lspconfig.jsonls.setup {on_attach = on_attach}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup {capabilities = capabilities, on_attach = on_attach}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup {capabilities = capabilities, on_attach = on_attach}

local lua_lsp_root_path = vim.fn.expand("~/.apps/all/lua-language-server")
local lua_lsp_bin_path = lua_lsp_root_path .. "/bin/Linux/lua-language-server"
local lua_lsp_main_lua = lua_lsp_root_path .. "/main.lua"
lspconfig.sumneko_lua.setup {
  cmd = {lua_lsp_bin_path, "-E", lua_lsp_main_lua},
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'use'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    }
  }
}

lspconfig.diagnosticls.setup {
  on_attach = on_attach,
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

function LspRename()
  local old_name = util.current_word()
  local new_name = vim.api.nvim_call_function('input', {'New name: ', old_name})
  if new_name then
    print('\nRenaming')
    vim.lsp.buf.rename(new_name)
  end
end

function LspReset()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.api.nvim_command('edit')
end

-- Keys
map.normal('gD', map.lua('vim.lsp.buf.declaration()'))
map.normal('gd', map.lua('vim.lsp.buf.definition()'))
map.normal('K', map.lua('vim.lsp.buf.hover()'))
map.normal('gi', map.lua('vim.lsp.buf.implementation()'))
map.normal('<space>k', map.lua('vim.lsp.buf.signature_help()'))
map.normal('<leader>wa', map.lua('vim.lsp.buf.add_workspace_folder()'))
map.normal('<leader>wr', map.lua('vim.lsp.buf.remove_workspace_folder()'))
map.normal('<leader>wl',
           map.lua('print(vim.inspect(vim.lsp.buf.list_workspace_folders()))'))
map.normal('gD', map.lua('vim.lsp.buf.type_definition()'))
map.normal('<leader>rn', map.lua('vim.lsp.buf.rename()'))
map.normal('gr', map.lua('vim.lsp.buf.references()'))
map.normal('<space>e', map.lua('vim.lsp.diagnostic.show_line_diagnostics()'))
map.normal('[d', map.lua('vim.lsp.diagnostic.goto_prev()'))
map.normal(']d', map.lua('vim.lsp.diagnostic.goto_next()'))
map.normal('<space>q', map.lua('vim.lsp.diagnostic.set_loclist()'))

return {on_attach = on_attach}
