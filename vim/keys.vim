" vim: foldmethod=marker
"
" Navigation {{{1
noremap <space> 20j
vnoremap <space> 20j
noremap - 20k
inoremap <c-l> <right>
inoremap <c-k> <up>
inoremap <c-j> <down>

" Find {{{1
noremap <cr> :nohls<cr>
noremap ,ff :Ack! <c-r>=expand("<cword>")<cr><cr>
vnoremap ,ff "9y:Ack! '<c-r>9'<cr>
noremap ,fp :Ack! 
noremap ,fr :Gsearch<cr>
noremap ,fg :call WebSearch("https://google.com/search?q=%query%")<cr>
noremap ,fo :call WebSearch("http://stackoverflow.com/search?q=%query%")<cr>
vnoremap ,fg "9y:call Browse("https://google.com/search?q=<c-r>9")<cr>
vnoremap ,fo "9y:call Browse("http://stackoverflow.com/search?q=<c-r>9")<cr>

" Documentation {{{1
nnoremap ,dm :call Browse("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")<cr>
nnoremap ,dj :call Browse("https://github.com/visionmedia/jade#readme")<cr>


" Window management {{{1

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap \l :silent !tput clear<cr>:redraw!<cr>
nnoremap ,, :silent !tput clear<cr>:redraw!<cr>

nnoremap ,sv :vs<cr>
nnoremap ,sp :sp<cr>

noremap Q :q<cr>

nnoremap <silent> <Leader>] :exe "resize " . (&lines * 2/3)<CR>
nnoremap <silent> <Leader>[ :exe "resize " . (&lines * 1/3)<CR>

" resize windows
" these are difficult to type, so I use the following iTerm mappings:
"
"   Control-Cmd-h => Esc-<
"   Control-Cmd-j => Esc--
"   Control-Cmd-k => Esc-+
"   Control-Cmd-l => Esc->

nnoremap _ <c-w>-
nnoremap + <c-w>+
nnoremap > <c-w>>
nnoremap < <c-w><


" Go to {{{1
noremap ,gb :CtrlPBuffer<cr>
noremap ,gc :CtrlPChange<cr>
noremap ,gd :cd <C-R>=expand("%:p:h")<cr>
noremap ,gf :CtrlP<cr>
noremap ,gg :NERDTreeToggle<cr>
noremap ,gm :CtrlPMRUFiles<cr>
noremap ,gn :NERDTreeFind<cr>
noremap ,go :call GotoAlternateFile()<cr>
noremap ,gs :UltiSnipsEdit<cr>
noremap ,gt :CtrlPTag<cr>
noremap ,gv :tabe $vimrc<cr>
noremap `` :CtrlPBufTag<cr>
inoremap <c-s> <c-o>:w<cr>

noremap <silent> <C-\> :NERDTreeFind<cr>:vertical res 30<cr>

" Editing {{{1
noremap <c-_> :call ToggleHebrew()<cr>
inoremap <c-_> <c-o>:call ToggleHebrew()<cr>
noremap ,ehs :SplitjoinSplit<cr>
noremap ,ehj :SplitjoinJoin<cr>
noremap ,es :set spell!<cr>
noremap <backspace> zc

" super yank (yank to * and + registers)
noremap ,ey "*Y"+Y
vnoremap ,ey "*ygv"+y
noremap ,ep "*p

noremap ,ef :e <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,et :tabe <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,rf :read <C-R>=expand("%:p:h") . $delimiter <cr>
noremap ,ew :w<cr>
noremap ,ww :w<cr>
noremap ,wq :wq<cr>

noremap ,e= :Tab /=<cr>
noremap ,e: :Tab /:\zs<cr>
noremap ,e\ :Tab /\|<cr>

" add symbols to the end of the lines:
noremap ,e1 :exec ":normal A <c-v><esc>" . (79 - strlen(getline("."))) . "A#"<cr>
noremap ,e2 :exec ":normal A <c-v><esc>" . (69 - strlen(getline("."))) . "A="<cr>
noremap ,e3 :exec ":normal A <c-v><esc>" . (59 - strlen(getline("."))) . "A-"<cr>

noremap ,tw :call ToggleWord()<cr>

inoremap <c-t> <c-r>=UltiSnips_ListSnippets()<cr>
inoremap <C-\> <c-o>ma<c-o>A;<c-o>`a


" From https://github.com/skwp/dotfiles/blob/master/vim/plugin/settings/stop-visual-paste-insanity.vim:
" If you visually select something and hit paste
" that thing gets yanked into your buffer. This
" generally is annoying when you're copying one item
" and repeatedly pasting it. This changes the paste
" command in visual mode so that it doesn't overwrite
" whatever is in your paste buffer.
vnoremap p "_dP

"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Surround {{{1

" ,# Surround a word with #{ruby interpolation}
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>

" ," Surround a word with "quotes"
map ," ysiw"
vmap ," c"<C-R>""<ESC>

" ,' Surround a word with 'single quotes'
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

" Run {{{1
noremap ,rr :w<cr>:call RunCurrentFile()<cr>
noremap ,rm :call MarkdownPreview()<cr>
vnoremap ,rl "xy:call netrw#NetrwBrowseX(@x, 0)<cr>
vnoremap ,rs "9y:<c-r>9<cr>
noremap ,rt :SuperTagger<cr>




" Git (v = version control) {{{1
noremap ,vs :Gstatus<cr>
noremap ,vrf :call Confirm("Revert current file?", "!git co %")<cr>
noremap ,vrp :!git co -p %<cr>
noremap ,vd :!clear; tmux clear-history; git diff %<cr>
"noremap ,vd :silent !clear; git diff %<cr>:redraw!<cr>
noremap ,vaf :!git add %<cr>
noremap ,vap :!git add -p %<cr>
noremap ,vh :silent !tig %<cr>:redraw!<cr>
noremap ,vc :Gcommit<cr>

" Spaces text object {{{1
xnoremap <silent><space> f oT o
xnoremap <silent>a<space> f oF o
xnoremap <silent>i<space> t oT o
" Testing {{{1
"noremap ,tt :call RunLastSpec()<cr>
"noremap ,tl :call RunSpecLine()<cr>
"noremap ,tf :call RunSpecFile()<cr>

" Misc {{{1
noremap ,ti :IndentGuidesToggle<cr>

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
