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
