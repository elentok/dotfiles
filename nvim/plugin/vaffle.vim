nnoremap - :call Elentok_GoUp()<cr>

function! Elentok_GoUp()
  if &filetype == 'vaffle'
    call vaffle#open_parent()
  elseif expand('%') == ''
    Vaffle
  else
    Vaffle %
  endif
endfunction

function! Elentok_VaffleMappings()
  nmap <buffer> mm <Plug>(vaffle-move-selected)
  nmap <buffer> mf <Plug>(vaffle-toggle-current)
  nmap <buffer> <Space><Space> <Plug>(vaffle-toggle-current)
endfunction

augroup Elentok_Vaffle
  autocmd!
  autocmd FileType vaffle call Elentok_VaffleMappings()
augroup END
