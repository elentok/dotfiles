" Grepper: settings {{{1
let g:grepper = {
  \ 'tools':  ['rg'],
  \ 'open':   1,
  \ 'switch': 0,
  \ 'jump':   1
\ }

" Grepper: keybindings {{{1
noremap <Leader>ff :Grepper -query '<c-r>=EscapeForQuery(expand("<cword>"))<cr>'<cr>
vnoremap <Leader>ff "9y:Grepper -query '<c-r>=EscapeRegisterForQuery(9)<cr>'<cr>
noremap <Leader>fc :Grepper<cr>
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Escape functions {{{1
func! EscapeForQuery(text)
  let text = substitute(a:text, '\v(\[|\]|\$|\^)', '\\\1', 'g')
  let text = substitute(text, "'", "''", 'g')
  return text
endfunc

func! EscapeRegisterForQuery(register)
  return EscapeForQuery(getreg(a:register))
endfunc

" Set vim's default 'grepprg' {{{1
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
endif

