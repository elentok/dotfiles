" vim: foldmethod=marker
"
" Navigation {{{1
noremap <space> 20j
vnoremap <space> 20j
noremap - 20k

" Search {{{1
noremap <cr> :nohls<cr>
vnoremap * "9y/<c-r>9<cr>
noremap ,sw :Ack! <c-r>=expand("<cword>")<cr><cr>
vnoremap ,sa "9y:Ack! '<c-r>9'<cr>
noremap ,sa :Ack! 
noremap ,ss :Gsearch<cr>
noremap ,sg :call WebSearch("https://google.com/search?q=%query%")<cr>
noremap ,so :call WebSearch("http://stackoverflow.com/search?q=%query%")<cr>
vnoremap ,sg "9y:call Browse("https://google.com/search?q=<c-r>9")<cr>
vnoremap ,so "9y:call Browse("http://stackoverflow.com/search?q=<c-r>9")<cr>

" Documentation {{{1
nnoremap ,dm :call Browse("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")<cr>


" Window management {{{1

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap \l :silent !tput clear<cr>:redraw!<cr>
nnoremap ,, :silent !tput clear<cr>:redraw!<cr>

noremap Q :q<cr>

nnoremap <silent> <Leader>] :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> <Leader>[ :exe "resize " . (&lines * 1/3)<CR>

" File management {{{1
noremap ,fb :CtrlPBuffer<cr>
noremap ,fc :CtrlPChange<cr>
noremap ,fd :cd <C-R>=expand("%:p:h")<cr>
noremap ,fe :e <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,fE :tabe <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,ff :NERDTreeFind<cr>
noremap ,fg :NERDTreeToggle<cr>
noremap ,fm :CtrlPMRUFiles<cr>
noremap ,fr :read <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,ft :CtrlPTag<cr>
noremap ,fv :tabe $vimrc<cr>
noremap `` :CtrlPBufTag<cr>
inoremap <c-s> <c-o>:w<cr>

" Editing {{{1
noremap <c-_> :call ToggleHebrew()<cr>
inoremap <c-_> <c-o>:call ToggleHebrew()<cr>
noremap ,ehs :SplitjoinSplit<cr>
noremap ,ehj :SplitjoinJoin<cr>
noremap ,es :set spell!<cr>
noremap <backspace> zc

" super yank (yank to * and + registers)
vnoremap ,ey "*ygv"+y


noremap ,e= :Tab /=<cr>
noremap ,e: :Tab /:\zs<cr>
noremap ,e\ :Tab /\|<cr>

" add symbols to the end of the lines:
noremap ,e1 :exec ":normal A <c-v><esc>" . (79 - strlen(getline("."))) . "A#"<cr>
noremap ,e2 :exec ":normal A <c-v><esc>" . (69 - strlen(getline("."))) . "A="<cr>
noremap ,e3 :exec ":normal A <c-v><esc>" . (59 - strlen(getline("."))) . "A-"<cr>

inoremap <c-l> <c-r>=UltiSnips_ListSnippets()<cr>

"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Run {{{1
noremap ,rr :w<cr>:call RunCurrentFile()<cr>
noremap ,rm :Mm<cr>:redraw!<cr>
vnoremap ,rl "xy:call netrw#NetrwBrowseX(@x, 0)<cr>
vnoremap ,rs "9y:<c-r>9<cr>
noremap ,rt :SuperTagger<cr>

" UltiSnips {{{1



" Git {{{1
noremap ,gs :Gstatus<cr>
noremap ,gr :!git co %<cr>
noremap ,gd :silent !git diff %<cr>:redraw!<cr>
noremap ,ga :!git add %<cr>
noremap ,gp :!git add -p %<cr>

" Testing {{{1
noremap ,tt :VimuxRunLastCommand<cr>
noremap ,tl :call RunSpecLine()<cr>
noremap ,tf :call RunSpecFile()<cr>

" MS-Windows {{{1
if g:os == 'windows'
  noremap <m-space> :simalt ~<cr>
  inoremap <m-space> <c-o>:simalt ~<cr>
  noremap <m-f10> :simalt ~x<cr>
  noremap <m-s-f10> :simalt ~r<cr>
endif

" Post Startup {{{1
func! PostStartupKeys()
  vmap <tab> >gv
  vmap <s-tab> <gv
endfunc

" prefixes:
" ,a
" ,b - camelcase back
" ,c
" ,d
" ,e - editing
" ,f - file management
" ,g - git
" ,q
" ,r - run/exec
" ,s - search
" ,t
" ,v
" ,w - camelcase forward
" ,x

