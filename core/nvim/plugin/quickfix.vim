augroup Elentok_QuickFix
  autocmd!
  autocmd FileType qf silent call InitQuickfix()
augroup END

function! InitQuickfix()
  " Always open quickfix window in full width
  if (getwininfo(win_getid())[0].loclist != 1)
    wincmd J
  endif

  " Map 'q' to close the quickfix window
  nnoremap <buffer> <silent> q :q<CR>
endfunction
