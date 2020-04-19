if g:lsp_mode != 'langclient'
  finish
endif

let g:autoformat_filetypes = [
      \ 'json', 'javascript', 'css', 'scss', 'typescript', 'typescript.tsx',
      \ 'java', 'markdown', 'yaml', 'python']

func! AutoFormat()
  if exists('g:autoformat_disable')
    return
  endif

  if index(g:autoformat_filetypes, &filetype) != -1
    Format
  endif
endfunc

augroup Elentok_Autoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END
