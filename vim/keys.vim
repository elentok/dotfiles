map <f8> :SuperTagger<cr>

noremap Q :q<cr>
noremap ,md :Mm<cr>:redraw!<cr>



vnoremap ,/ "9y/<c-r>9<cr>
vnoremap ,! "9y:<c-r>9<cr>


" Basics
map \s :set spell!<cr>
map <space> 20j
vmap <space> 20j
map - 20k
map <backspace> zc
imap <c-s> <c-o>:w<cr>
" super yank (yank to * and + registers)
vmap \y "*ygv"+y

imap <f2> <c-o>:call ToggleHebrew()<cr>
map <f2> :call ToggleHebrew()<cr>
imap <c-_> <c-o>:call ToggleHebrew()<cr>

map <F3> :TagbarToggle<cr>

noremap ,es :SplitjoinSplit<cr>
noremap ,ej :SplitjoinJoin<cr>

" File navigation
noremap ,ge :e <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,gt :tabe <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,gr :read <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,gd :cd <C-R>=expand("%:p:h")<cr><cr>
"map ,c :silent !start cmd.exe /k cd /d "<C-R>=expand("%:p:h")<cr>"<cr>
noremap ,gv :tabe $vimrc<cr>
noremap ,gV :tabe $vimfiles/bundle/vim-rails-extra/plugin/rails-extra.vim<cr>
noremap ,gg :NERDTreeToggle<cr>
noremap ,gf :NERDTreeFind<cr>
noremap ,b :CtrlPBuffer<cr>
noremap `` :CtrlPBufTag<cr>
noremap ,gt :CtrlPTag<cr>
noremap ,gm :CtrlPMRUFiles<cr>
noremap ,gc :CtrlPChange<cr>

nnoremap <silent> <Leader>] :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> <Leader>[ :exe "resize " . (&lines * 1/3)<CR>

map <c-f12> :setlocal foldexpr=MyFoldingExpr(v:lnum)<cr>:setlocal foldmethod=expr<cr>
map <c-s-f12> :setlocal foldmethod=manual<cr>zE
map <c-f11> :vimgrep /^\*/ %<cr>:copen<cr>

map <m-space> :simalt ~<cr>
imap <m-space> <c-o>:simalt ~<cr>
map <m-f10> :simalt ~x<cr>
map <m-s-f10> :simalt ~r<cr>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap \l :silent !tput clear<cr>:redraw!<cr>

" select a link and press "gx"
vmap gx "xy:call netrw#NetrwBrowseX(@x, 0)<cr>
 
" add symbols to the end of the lines:
map `1 :exec ":normal A <c-v><esc>" . (79 - strlen(getline("."))) . "A#"<cr>
map `2 :exec ":normal A <c-v><esc>" . (69 - strlen(getline("."))) . "A="<cr>
map `3 :exec ":normal A <c-v><esc>" . (59 - strlen(getline("."))) . "A-"<cr>
 
" run the selected text:
nmap <c-s-cr> 0v$"xy:silent exec ":!cmd /c start \"VimCmd\" " . @x<cr>
"vmap <c-cr> "xy:silent exec ":!cmd /c start \"VimCmd\" " . @x<cr>
"nmap <c-cr> :silent exec ":!start cmd /k " . expand("<cword>")<cr>

" Tabular
noremap \t= :Tab /=<cr>
noremap \t: :Tab /:\zs<cr>

map \gs :Gstatus<cr>

func! PostStartupKeys()
  vmap <tab> >gv
  vmap <s-tab> <gv
endfunc

map <cr> :nohls<cr>

noremap ,ff :Ack! <c-r>=expand("<cword>")<cr><cr>
vnoremap ,ff "9y:Ack! '<c-r>9'<cr>
noremap ,fa :Ack! 

"map ,gg :call WebSearch("https://google.com/search?q=%query%")<cr>
