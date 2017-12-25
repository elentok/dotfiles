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

" Snippets {{{1
let g:UltiSnipsExpandTrigger="<c-u>"
" let g:UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
" inoremap <silent> <c-u> <c-r>=cm#sources#ultisnips#trigger_or_popup("\<Plug>(ultisnips_expand)")<cr>

" When running inside abudo disable the 'violent' quit commands {{{1
if $NVIM_KEEP_ALIVE != "" || exists("g:gui_oni")
  cabbr qa echo ':qa has been disabled'<cr>
  cabbr wqa echo ':wqa has been disabled'<cr>
  cabbr cq echo ':cq has been disabled'<cr>

  let $NVIM_KEEP_ALIVE=""
endif

" Git {{{1

command! Gca Gcommit --amend
command! Gpsr Git push review
