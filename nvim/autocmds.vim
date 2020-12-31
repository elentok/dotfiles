augroup Elentok_Misc
  autocmd!
  autocmd VimEnter * set t_vb=
  autocmd VimEnter * echomsg printf("Took %dms to load", g:vimrc_time)

  autocmd BufRead,BufEnter * set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

  autocmd BufRead,BufEnter *.ino         setlocal filetype=arduino
  autocmd BufRead,BufEnter .babelrc      setlocal filetype=json

  " autocmd FileType arduino    setlocal cindent
  autocmd FileType go         setlocal ts=4 sw=4 softtabstop=4 noexpandtab nolist
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags ai
  autocmd FileType java       setlocal omnifunc=eclim#java#complete#CodeComplete
    \ completefunc=eclim#java#complete#CodeComplete
  autocmd FileType javascript setlocal foldmethod=expr
  autocmd FileType typescript setlocal textwidth=100
  autocmd FileType ruby       setlocal omnifunc=
  autocmd Filetype python     setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd FileType gitcommit,markdown setlocal spell spellcapcheck=
  autocmd FileType gitcommit  setlocal comments=fb:-,fb:* colorcolumn=72 textwidth=72
  autocmd FileType markdown   setlocal textwidth=80
  autocmd FileType vim        setlocal nobomb

  autocmd VimEnter * call PostStartupKeys()
augroup END
