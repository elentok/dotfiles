" vim: foldmethod=marker
"

" Find {{{1

" Window management {{{1
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

nnoremap <Leader>l :silent !tput clear<cr>:redraw!<cr>

nnoremap <Leader>qq :confirm qall<cr>

noremap <Leader>wo :WinOnly<cr>
noremap <Leader>tq :tabc<cr>

nnoremap <silent> <Leader>12 :exe "vertical resize " . (&columns * 1/2)<CR>
nnoremap <silent> <Leader>13 :exe "vertical resize " . (&columns * 1/3)<CR>
nnoremap <silent> <Leader>14 :exe "vertical resize " . (&columns * 1/4)<CR>
nnoremap <silent> <Leader>23 :exe "vertical resize " . (&columns * 2/3)<CR>
nnoremap <silent> <Leader>34 :exe "vertical resize " . (&columns * 3/4)<CR>
nnoremap <silent> <Leader>11 :exe "vertical resize " . &columns<CR>

nnoremap <silent> \12 :exe "resize " . (&lines * 1/2)<CR>
nnoremap <silent> \13 :exe "resize " . (&lines * 1/3)<CR>
nnoremap <silent> \14 :exe "resize " . (&lines * 1/4)<CR>
nnoremap <silent> \23 :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> \34 :exe "resize " . (&lines * 3/4)<CR>
nnoremap <silent> \11 :exe "resize " . &lines<CR>


" Editing {{{1
noremap <Leader>ehs :SplitjoinSplit<cr>
noremap <Leader>ehj :SplitjoinJoin<cr>

noremap <Leader>ww :w<cr>
noremap <Leader>wq :wq<cr>

" vnoremap <silent> <Enter> :EasyAlign<Enter>

" add symbols to the end of the lines:
noremap <Leader>e1 :exec ":normal A <c-v><esc>" . (79 - strlen(getline("."))) . "A#"<cr>
noremap <Leader>e2 :exec ":normal A <c-v><esc>" . (69 - strlen(getline("."))) . "A="<cr>
noremap <Leader>e3 :exec ":normal A <c-v><esc>" . (59 - strlen(getline("."))) . "A-"<cr>

" inoremap <C-\> <c-o>ma<c-o>A;<c-o>`a

" Surround {{{1

vmap <Leader>b c**<C-R>"**<ESC>
inoremap <c-b> ****<left><left>

" Profiling {{{1

nnoremap <silent> <leader>PP :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>PQ :exe ":profile pause"<cr>:noautocmd qall!<cr>
