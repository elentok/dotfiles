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

lua require('elentok/lsp')

augroup ElentokLspConfig
  autocmd BufEnter * lua lspCompletionOnAttach()
augroup END

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Avoid showing message extra message when using completion
set shortmess+=c"

command! Format lua vim.lsp.buf.formatting_sync(nil, 1000)
command! LspInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))
