augroup Elentok_Misc
  autocmd!
  autocmd VimEnter * set t_vb=
  autocmd VimEnter * echomsg printf("Took %dms to load", g:vimrc_time)

  autocmd BufRead,BufEnter *.ino         setlocal filetype=arduino

  " autocmd FileType arduino    setlocal cindent
  autocmd FileType go         setlocal ts=4 sw=4 softtabstop=4 noexpandtab nolist
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags ai
  autocmd FileType java       setlocal omnifunc=eclim#java#complete#CodeComplete
    \ completefunc=eclim#java#complete#CodeComplete
  autocmd Filetype python     setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd Filetype lua        setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd FileType gitcommit,hgcommit setlocal spell spellcapcheck=
  autocmd FileType gitcommitsetlocal comments=fb:-,fb:* colorcolumn=72 textwidth=72
  autocmd FileType gitcommit,hgcommit  setlocal comments=fb:-,fb:* colorcolumn=80 textwidth=80
  autocmd FileType vim        setlocal nobomb

  autocmd VimEnter * call PostStartupKeys()

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
