" fix nerdtree width

augroup Elentok_NerdTreeFixWidth
  autocmd BufEnter *
    \ if exists("b:NERDTree")   |
    \   call FixNERDTreeWidth() |
    \ endif
augroup END

function! FixNERDTreeWidth()
  let winwidth = winwidth(".")
  if winwidth < g:NERDTreeWinSize
    exec("silent vertical resize " . g:NERDTreeWinSize)
  endif
endfunc
