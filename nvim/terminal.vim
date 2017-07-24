" vim: foldmethod=marker

" Exit insert mode {{{1
tnoremap <c-\><c-\> <c-\><c-n>
tnoremap <c-_> <c-\><c-n>
tnoremap <c-cr> <c-\><c-n>
tnoremap <c-q> <c-\><c-n>

" Fix <C-h> (https://github.com/neovim/neovim/issues/2048) {{{1
nmap <BS> <C-h>

" Move to other windows {{{1
tnoremap <c-w> <c-\><c-n><c-w>
tnoremap <c-h> <c-\><c-n><c-w>h
tnoremap <c-j> <c-\><c-n><c-w>j
tnoremap <c-k> <c-\><c-n><c-w>k
tnoremap <c-l> <c-\><c-n><c-w>l

" Tmux-like <c-a> mappings {{{1

nnoremap <c-a>r :so $vimrc<cr>
nnoremap <c-a>c :tabe<cr>:terminal<cr>
tnoremap <c-a>a <c-a>
tnoremap <c-a>c <c-\><c-n>:tabe<cr>:terminal<cr>

nnoremap <c-a>v :TermVertical<cr>
tnoremap <c-a>v <c-\><c-n>:TermVertical<cr>
command! TermVertical wincmd v | wincmd l | terminal

nnoremap <c-a>s :TermHorizontal<cr>
tnoremap <c-a>s <c-\><c-n>:TermHorizontal<cr>
command! TermHorizontal wincmd s | wincmd j | terminal

" Remain in insert mode {{{1
augroup Elentok_Terminal
  autocmd!
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert
augroup END

" Open all hidden terminals in a tab {{{1
command! TermClean call OpenHiddenTerminals()
function! OpenHiddenTerminals()
  let terminals = FindHiddenTerminals()

  if len(terminals) == 0
    echomsg "There are no hidden terminals"
    return
  endif

  tabnew
  let is_first = 1
  for term in terminals
    if !is_first
      wincmd s
    endif

    exec "buffer " . term

    let is_first = 0
  endfor
  echomsg "Opened " . len(terminals) . " hidden terminals"
endfunction

function! FindHiddenTerminals()
  let terminals = []

  let all_buffers=[]
  call map(range(1, tabpagenr('$')), 'extend(all_buffers, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(all_buffers, v:val)==-1')
    if bufname(buf) =~ "^term://"
      call add(terminals, buf)
    endif
  endfor

  return terminals
endfunc

" Use neovim-remote to prevent opening vim inside the terminal {{{1
" let $VISUAL = 'nvr -cc split --remote-wait'
