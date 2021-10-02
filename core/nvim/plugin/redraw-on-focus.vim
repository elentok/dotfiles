" Redraw when gaining focus

if !exists('#FocusGained')
  finish
endif

augroup Elentok_AutoRedraw
  autocmd!
  autocmd FocusGained * redraw!
augroup END
