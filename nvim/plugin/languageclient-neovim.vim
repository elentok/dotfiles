if g:lsp_mode != 'langclient'
  finish
endif

let g:LanguageClient_serverCommands = {
  \ 'python': ['pyls'],
  \ 'sh': ['bash-language-server', 'start'],
  \ 'javascript': ['javascript-typescript-stdio'],
  \ 'typescript': ['javascript-typescript-stdio'],
  \ 'javascript.jsx': ['javascript-typescript-stdio'],
  \ 'typescript.tsx': ['javascript-typescript-stdio'],
  \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
  \ }

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <leader>rn :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>gs :call LanguageClient#textDocument_documentSymbol()<CR>

command! Format call LanguageClient#textDocument_formatting_sync()
