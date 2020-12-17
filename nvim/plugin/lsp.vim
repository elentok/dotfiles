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
require'lspconfig'.pyls.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.bashls.setup{}
EOF

augroup ElentokLspConfig
  autocmd BufEnter * lua require'completion'.on_attach()
augroup END

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Avoid showing message extra message when using completion
set shortmess+=c"
