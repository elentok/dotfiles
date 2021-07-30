local util = require('elentok/util')

local lspconfig = util.safe_require('lspconfig')
if not lspconfig then
  print('Warning: lspconfig not found, skipping initialization.')
  return
end

function on_attach(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  nnoremap = util.create_buf_map_func(bufnr, 'n')
  nnoremap('gD', 'vim.lsp.buf.declaration()')
  nnoremap('gd', 'vim.lsp.buf.definition()')
  nnoremap('K', 'vim.lsp.buf.hover()')
  nnoremap('gi', 'vim.lsp.buf.implementation()')
  nnoremap('<space>k', 'vim.lsp.buf.signature_help()')
  nnoremap('<leader>wa', 'vim.lsp.buf.add_workspace_folder()')
  nnoremap('<leader>wr', 'vim.lsp.buf.remove_workspace_folder()')
  nnoremap('<leader>wl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
  nnoremap('gD', 'vim.lsp.buf.type_definition()')
  nnoremap('<leader>rn', 'vim.lsp.buf.rename()')
  nnoremap('gr', 'vim.lsp.buf.references()')
  nnoremap('<space>e', 'vim.lsp.diagnostic.show_line_diagnostics()')
  nnoremap('[d', 'vim.lsp.diagnostic.goto_prev()')
  nnoremap(']d', 'vim.lsp.diagnostic.goto_next()')
  nnoremap('<space>q', 'vim.lsp.diagnostic.set_loclist()')

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    nnoremap("<space>f", "lua vim.lsp.buf.formatting()")
  elseif client.resolved_capabilities.document_range_formatting then
    nnoremap("<space>f", "lsp.buf.range_formatting()")
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

lspconfig = require'lspconfig'
lspconfig.pyright.setup{ on_attach = on_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.bashls.setup{ on_attach = on_attach }
lspconfig.vimls.setup{ on_attach = on_attach }
lspconfig.yamlls.setup{ on_attach = on_attach }
lspconfig.jsonls.setup{ on_attach = on_attach }
lspconfig.html.setup{ on_attach = on_attach }

local lua_lsp_root_path = vim.fn.expand("~/.apps/all/lua-language-server")
local lua_lsp_bin_path = lua_lsp_root_path .. "/bin/Linux/lua-language-server"
local lua_lsp_main_lua = lua_lsp_root_path .. "/main.lua"
lspconfig.sumneko_lua.setup{
  cmd = {lua_lsp_bin_path, "-E", lua_lsp_main_lua},
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim', 'use'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  }
}

lspconfig.diagnosticls.setup{
  on_attach = on_attach,
  filetypes = {"sh"},
  init_options = {
    filetypes = {
      sh = "shellcheck",
    },
    formatFiletypes = {
      sh = "shfmt"
    },
    linters = {
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = { "--format", "json", "-" },
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
        },
      },
    },
    formatters = {
      shfmt = {
        command = "shfmt",
        args = {"-i", "2", "-bn", "-ci", "-sr"},
      }
    }
  }
}


function LspRename ()
  local old_name = util.current_word()
  local new_name = vim.api.nvim_call_function('input', {'New name: ', old_name})
  if new_name then
    print('\nRenaming')
    vim.lsp.buf.rename(new_name)
  end
end

function LspReset ()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.api.nvim_command('edit')
end

return { on_attach = on_attach }
