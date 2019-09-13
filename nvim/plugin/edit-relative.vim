noremap <Leader>ef :e <C-R>=EscapeCurrentFileDir() . $delimiter <cr>
noremap <Leader>et :tabe <C-R>=EscapeCurrentFileDir() . $delimiter <cr>
noremap <Leader>rf :read <C-R>=EscapeCurrentFileDir() . $delimiter <cr>

function! EscapeCurrentFileDir()
  let path = expand("%:p:h")
  let path = substitute(path, ' ', '\\ ', 'g')
  return path
endfunction
