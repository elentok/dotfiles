augroup Elentok_YankOSC52
  autocmd!
  autocmd TextYankPost * call system('yank-osc52', v:event['regcontents'])
augroup END
