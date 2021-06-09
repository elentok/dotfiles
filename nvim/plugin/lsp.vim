" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" imap <tab> <Plug>(completion_smart_tab)
" imap <s-tab> <Plug>(completion_smart_s_tab)
imap <silent> <c-space> <Plug>(completion_trigger)

" " Avoid showing message extra message when using completion
" set shortmess+=c"

command! Format lua vim.lsp.buf.formatting_sync(nil, 1000)
" command! LspInfo lua LspInfo()
" command! LspRename lua LspRename()
" command! LspReset lua LspReset()

" let g:completion_matching = ['fuzzy', 'substring', 'exact', 'all']
" let g:completion_matching_smart_case = 1
