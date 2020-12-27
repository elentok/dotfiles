local util = require('elentok/util')

local function lspConfigSetup ()
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
end

function LspCompletionOnAttach ()
  local completion = util.safe_require('completion')
  if not completion then
    return
  end

  completion.on_attach()
end

function LspInfo ()
  local info = vim.inspect(vim.lsp.buf_get_clients())
  local lines = vim.split(info, "\n", true)
  util.open_window('LSP INFO', lines)
end

lspConfigSetup()
