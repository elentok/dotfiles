noremap <Leader>ef :e <C-R>=EscapeCurrentFileDir() . "/" <cr>
noremap <Leader>et :tabe <C-R>=EscapeCurrentFileDir() . "/" <cr>
noremap <Leader>rf :read <C-R>=EscapeCurrentFileDir() . "/" <cr>

function! EscapeCurrentFileDir()
  let path = expand("%:p:h")
  let path = substitute(path, ' ', '\\ ', 'g')
  return path
endfunction
