nnoremap - :call Elentok_GoUp()<cr>

function! Elentok_GoUp()
  if &filetype == 'vaffle'
    call vaffle#open_parent()
  else
    Vaffle %
  endif
endfunction
