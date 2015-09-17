augroup Elentok_Misc
  autocmd!
  autocmd VimEnter * set t_vb=

  autocmd BufRead,BufEnter *.applescript setlocal filetype=applescript
  autocmd BufRead,BufEnter *.rxls        setlocal filetype=ruby
  autocmd BufRead,BufEnter *.ino         setlocal filetype=arduino
  autocmd BufRead,BufEnter *.hamlc       setlocal filetype=haml
  autocmd BufRead,BufEnter *.hamljs      setlocal filetype=haml

  autocmd FileType arduino    setlocal cindent
  autocmd FileType css,scss   setlocal foldmethod=marker foldmarker={,}
    \ omnifunc=csscomplete#CompleteCSS
  autocmd FileType go         setlocal ts=8 sw=8 softtabstop=8 noexpandtab nolist
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags ai
  autocmd FileType java       setlocal omnifunc=eclim#java#complete#CodeComplete
    \ completefunc=eclim#java#complete#CodeComplete
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    \ nocindent smartindent
  autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType ruby       setlocal omnifunc=
  autocmd FileType xml        setlocal foldmethod=syntax
  autocmd Filetype python     setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd FileType gitcommit  setlocal comments=fb:-,fb:* colorcolumn=72
  autocmd FileType vim setlocal nobomb

  autocmd FileType gitcommit,markdown       setlocal spell spellcapcheck=
  autocmd FileType coffee,yaml FoldByIndent setlocal foldmethod=expr
    \ nofoldenable foldexpr=IndentFoldExpr(v:lnum)

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd VimEnter * call PostStartupKeys()

  " remap <cr> in quickfix buffers
  autocmd BufRead * call RemapCrInQuickFixBuffers()

  " autocompile coffeescript
  autocmd BufWritePost *.coffee call CoffeeMake()

  " fix nerdtree width
  autocmd BufEnter *
    \ if exists("b:NERDTreeType") |
    \   call FixNERDTreeWidth()   |
    \ endif

  if has('nvim')
    autocmd! BufWritePost * Neomake
  endif
augroup END
