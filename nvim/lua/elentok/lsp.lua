function safeRequire (name)
  status, module = pcall(require, name)
  if(status) then
    return module
  else
    print(string.format('WARNING: lua module "%s" is missing', name))
    return nil
  end
end

function lspConfigSetup ()
  lspconfig = safeRequire('lspconfig')
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
        diagnostics = {
          globals = {'vim'}
        }
      }
    }
  }
end

function lspCompletionOnAttach ()
  completion = safeRequire('completion')
  if not completion then
    return
  end

  completion.on_attach()
end

lspConfigSetup()
