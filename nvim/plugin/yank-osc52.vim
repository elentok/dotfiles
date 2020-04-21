augroup Elentok_YankOSC52
  autocmd!
  autocmd TextYankPost * call YankOsc52()
augroup END

function YankOsc52()
  let contents = join(v:event['regcontents'], "\n")

  if v:event['regtype'] ==# 'V'
    let contents = contents . "\n"
  endif

  call system('yank-osc52', contents)
endfunction
