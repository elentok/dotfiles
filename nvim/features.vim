" vim: foldmethod=marker

" Tab: Cd to buffer root {{{1

noremap <Leader>tcd :TabCdToBufRoot<cr>

command! TabCdToBufRoot call TabCdToBufRoot()

function! BufGetRoot()
  return systemlist("git-root '" . expand("%") . "'")[0]
endfunction

function! TabCdToBufRoot()
  let root = BufGetRoot()
  exec "tcd " . root
  echomsg "Changed tab directory to: " . root
endfunction

" Automatic formatting (prettier) {{{1
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_java_google = {'exe': 'google-java-format'}
let g:neoformat_enabled_java = ['google']

let g:autoformat_filetypes = ['json', 'javascript', 'css', 'scss']

func! AutoFormat()
  if index(g:autoformat_filetypes, &filetype) != -1
    Neoformat
  endif
endfunc

augroup Elentok_Neoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END
