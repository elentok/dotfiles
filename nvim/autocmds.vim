augroup Elentok_Misc
  autocmd!
  autocmd VimEnter * set t_vb=
  autocmd VimEnter * echomsg printf("Took %dms to load", g:vimrc_time)

  autocmd BufRead,BufEnter *.applescript setlocal filetype=applescript
  autocmd BufRead,BufEnter *.rxls        setlocal filetype=ruby
  autocmd BufRead,BufEnter *.ino         setlocal filetype=arduino
  autocmd BufRead,BufEnter *.hamlc       setlocal filetype=haml
  autocmd BufRead,BufEnter *.hamljs      setlocal filetype=haml
  autocmd BufRead,BufEnter *.es6         setlocal filetype=javascript
  autocmd BufRead,BufEnter .babelrc      setlocal filetype=json

  autocmd FileType arduino    setlocal cindent
  autocmd FileType css,scss   setlocal foldmethod=marker foldmarker={,}
    \ omnifunc=csscomplete#CompleteCSS
  autocmd FileType go         setlocal ts=4 sw=4 softtabstop=4 noexpandtab nolist
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags ai
  autocmd FileType java       setlocal omnifunc=eclim#java#complete#CodeComplete
    \ completefunc=eclim#java#complete#CodeComplete
  autocmd FileType javascript setlocal nocindent smartindent foldmethod=syntax
  autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType ruby       setlocal omnifunc=
  autocmd FileType xml        setlocal foldmethod=syntax
  autocmd Filetype python     setlocal ts=4 softtabstop=4 shiftwidth=4
  autocmd FileType gitcommit,markdown setlocal spell spellcapcheck=
  autocmd FileType gitcommit  setlocal comments=fb:-,fb:* colorcolumn=72 textwidth=72
  autocmd FileType markdown   setlocal textwidth=80
  autocmd FileType vim setlocal nobomb

  autocmd FileType coffee,yaml        FoldByIndent

  " RestoreCursorPosition:
  "
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

  " fix nerdtree width
  autocmd BufEnter *
    \ if exists("b:NERDTree")   |
    \   call FixNERDTreeWidth() |
    \ endif
augroup END
