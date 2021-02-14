if vim.g.lsp_mode ~= 'native' then
  return
end


local util = require('elentok/util')
local a = vim.api

local lspconfig = util.safe_require('lspconfig')
if not lspconfig then
  return
end

vim.g.completion_matching = {'fuzzy', 'substring', 'exact', 'all'}
vim.g.completion_matching_smart_case = 1

function on_attach(client, bufnr)
  print('on attach!')
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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

  -- setup completion
  require('completion').on_attach()
end

lspconfig = require'lspconfig'
lspconfig.pyls.setup{ on_attach = on_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.bashls.setup{ on_attach = on_attach }
lspconfig.vimls.setup{ on_attach = on_attach }
lspconfig.yamlls.setup{ on_attach = on_attach }
lspconfig.jsonls.setup{ on_attach = on_attach }
lspconfig.html.setup{ on_attach = on_attach }
lspconfig.sumneko_lua.setup{
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
        globals = {'vim'},
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
  local new_name = a.nvim_call_function('input', {'New name: ', old_name})
  if new_name then
    print('\nRenaming')
    vim.lsp.buf.rename(new_name)
  end
end

function LspReset ()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
  vim.api.nvim_command('edit')
end

function LspInfo ()
  local info = vim.inspect(vim.lsp.buf_get_clients())
  local lines = vim.split(info, "\n", true)
  util.open_window('LSP INFO', lines)
end

return { on_attach = on_attach }
