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
let g:neoformat_enabled_json = ['prettier']
let g:neoformat_enabled_scss = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_java_google = {
      \ 'exe': 'google-java-format',
      \ 'args': ['-'],
      \ 'stdin': 1}
let g:neoformat_enabled_java = ['google']

let g:autoformat_filetypes = ['json', 'javascript', 'css', 'scss', 'typescript', 'java']

func! AutoFormat()
  if exists("b:af") && b:af == 0
    return
  endif
  if index(g:autoformat_filetypes, &filetype) != -1
    Neoformat
  endif
endfunc

func! AutoFormatToggle()
  if exists("b:af")
    let b:af = !b:af
  else
    let b:af = 0
  end
  echo "AutoFormat: " . (b:af ? "on" : "off")
endfunc

augroup Elentok_Neoformat
  autocmd!
  autocmd BufWritePre * call AutoFormat()
augroup END

nnoremap ,taf :call AutoFormatToggle()<cr>

" Copy over SSH {{{1

" These functions will run on the ssh server (not the client).
" On the client you need to start the clipboard listening server:
"
"   while (true); do nc -l 7777 | pbcopy; done
"
" Or:
"
"   daemon start clipboard clipboard-server

func! CopyThroughSSH() range
  normal gv"sy
  call system("nc -q0 localhost 7777", @s)
endfunc

vnoremap <Leader>ys :call CopyThroughSSH()<cr>



" Git {{{1

command! Gca Gcommit --amend

" Intellisense/Autocomplete {{{1
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ }

let g:LanguageClient_diagnosticsEnable = 0

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

set completefunc=LanguageClient#complete

function! SmartTab()
  " if the completion popup is visible
  if pumvisible()
    return "\<c-n>"
  elseif IsBeginningOfLine() || IsLastCharWhitespace()
    return "\<tab>"
  else
    if &completefunc != ''
      return "\<c-x>\<c-u>"
    elseif &omnifunc != ''
      return "\<c-x>\<c-o>"
    else
      return "\<c-x>\<c-n>"
    end
  end
endfunction

function! IsBeginningOfLine()
  return col('.') == 1
endfunction

function! IsLastCharWhitespace()
  return getline('.')[col('.') - 2]  =~ '\s'
endfunction

inoremap <expr><tab> SmartTab()
