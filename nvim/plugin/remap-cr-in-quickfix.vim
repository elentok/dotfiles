augroup Elentok_RemapCrInQuickFix
  " remap <cr> in quickfix buffers
  autocmd BufRead * call RemapCrInQuickFixBuffers()
augroup END

func! RemapCrInQuickFixBuffers()
  if &buftype == 'quickfix'
    nnoremap <buffer> <cr> <cr>
  end
endfunc
