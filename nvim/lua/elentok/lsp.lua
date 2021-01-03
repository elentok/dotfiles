local util = require('elentok/util')
local a = vim.api

local function lsp_config_setup ()
  local lspconfig = util.safe_require('lspconfig')
  if not lspconfig then
    return
  end

  lspconfig = require'lspconfig'
  lspconfig.pyls.setup{}
  lspconfig.tsserver.setup{}
  lspconfig.bashls.setup{}
  lspconfig.vimls.setup{}
  lspconfig.yamlls.setup{}
  lspconfig.jsonls.setup{}
  lspconfig.html.setup{}
  lspconfig.sumneko_lua.setup{
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
end

function LspCompletionOnAttach ()
  local completion = util.safe_require('completion')
  if not completion then
    return
  end

  completion.on_attach()
end

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

lsp_config_setup()
