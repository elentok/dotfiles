let g:autoformat_filetypes = [
      \ 'json', 'javascript', 'css', 'scss', 'typescript', 'typescript.tsx',
      \ 'java', 'markdown', 'yaml']

func! AutoFormat()
  if index(g:autoformat_filetypes, &filetype) != -1
    call CocAction('format')
  endif
endfunc

augroup Elentok_Autoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END
