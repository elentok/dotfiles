if g:lsp_mode != 'native'
  finish
endif

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> ]g    <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [g    <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

set omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF

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
end

function lspCompletionOnAttach ()
  completion = safeRequire('completion')
  if not completion then
    return
  end

  completion.on_attach()
end

lspConfigSetup()

EOF

augroup ElentokLspConfig
  autocmd BufEnter * lua lspCompletionOnAttach()
augroup END

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Avoid showing message extra message when using completion
set shortmess+=c"

command! Format lua vim.lsp.buf.formatting_sync(nil, 1000)
