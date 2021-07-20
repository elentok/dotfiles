" vim: foldmethod=marker
"

"inoremap <esc> <nop>
inoremap jk <esc>

" Navigation {{{1
" noremap <space> 20j
" vnoremap <space> 20j
" noremap - 20k
inoremap <c-l> <right>
"inoremap <c-k> <up>
"inoremap <c-j> <down>
inoremap <c-e> <c-o>$

" Find {{{1
nnoremap <cr> :nohls<cr><cr>

noremap <Leader>fg :call WebSearch("https://google.com/search?q=%query%")<cr>
noremap <Leader>fo :call WebSearch("http://stackoverflow.com/search?q=%query%")<cr>
vnoremap <Leader>fg "9y:call Browse("https://google.com/search?q=<c-r>9")<cr>
vnoremap <Leader>fo "9y:call Browse("http://stackoverflow.com/search?q=<c-r>9")<cr>

"nnoremap / /\v
"vnoremap / /\v

" Documentation {{{1
nnoremap <Leader>dm :call Browse("https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet")<cr>
nnoremap <Leader>dj :call Browse("https://github.com/visionmedia/jade#readme")<cr>
nnoremap <Leader>dk :e $DOTF/docs/keys.md<cr>

" Window management {{{1
nnoremap <silent> <c-h> <c-w>h
nnoremap <silent> <c-j> <c-w>j
nnoremap <silent> <c-k> <c-w>k
nnoremap <silent> <c-l> <c-w>l

nnoremap <Leader>l :silent !tput clear<cr>:redraw!<cr>
nnoremap <Leader><Leader> :silent !tput clear<cr>:redraw!<cr>

nnoremap <Leader>qq :confirm qall<cr>

noremap <Leader>wo :WinOnly<cr>
noremap <Leader>tq :tabc<cr>

" using yadr's window killer instead of a simple :q
"noremap Q :q<cr>

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

" resize windows
" these are difficult to type, so I use the following iTerm mappings:
"
"   Control-Cmd-h => Esc-<
"   Control-Cmd-j => Esc--
"   Control-Cmd-k => Esc-+
"   Control-Cmd-l => Esc->

" TODO: try to get these working again:
" nnoremap _ <c-w>-
" nnoremap + <c-w>+
" nnoremap > <c-w>>
" nnoremap < <c-w><

nnoremap coq :cclose<cr>


" Go to {{{1
noremap <Leader>gd :cd <C-R>=expand("%:p:h")<cr>
noremap <Leader>go :call GotoAlternateFile()<cr>
inoremap <c-s> <c-o>:w<cr>

noremap <Leader>oc :Calendar -view=year -split=vertical -width=27<cr>

" Editing {{{1
noremap <Leader>ehs :SplitjoinSplit<cr>
noremap <Leader>ehj :SplitjoinJoin<cr>
noremap <backspace> zc

" super yank (yank to * and + registers)
noremap <Leader>ey "*Y"+Y
vnoremap <Leader>ey "*ygv"+y
noremap <Leader>ep "*p

noremap <Leader>ew :w<cr>
noremap <Leader>ww :w<cr>
noremap <Leader>wq :wq<cr>
noremap <Leader>er :call RevertFile()<cr>
noremap <Leader>e"' :s/"/'/g<cr>
noremap <Leader>e'" :s/'/"/g<cr>
noremap <Leader>rws :%s/\s\+$//<cr>

nnoremap <c-s> :w<cr>
inoremap <c-s> <c-o>:w<cr>

vnoremap <silent> <Enter> :EasyAlign<Enter>

" add symbols to the end of the lines:
noremap <Leader>e1 :exec ":normal A <c-v><esc>" . (79 - strlen(getline("."))) . "A#"<cr>
noremap <Leader>e2 :exec ":normal A <c-v><esc>" . (69 - strlen(getline("."))) . "A="<cr>
noremap <Leader>e3 :exec ":normal A <c-v><esc>" . (59 - strlen(getline("."))) . "A-"<cr>

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

noremap ,ya :%y+<cr>

" Surround {{{1

vmap <Leader>b c**<C-R>"**<ESC>
inoremap <c-b> ****<left><left>

" <Leader># Surround a word with #{ruby interpolation}
map <Leader># ysiw#
vmap <Leader># c#{<C-R>"}<ESC>

" <Leader>" Surround a word with "quotes"
map <Leader>" ysiw"
vmap <Leader>" c"<C-R>""<ESC>

" <Leader>' Surround a word with 'single quotes'
map <Leader>' ysiw'
vmap <Leader>' c'<C-R>"'<ESC>

" <Leader>) or <Leader>( Surround a word with (parens)
" The difference is in whether a space is put in
map <Leader>( ysiw(
map <Leader>) ysiw)
vmap <Leader>( c( <C-R>" )<ESC>
vmap <Leader>) c(<C-R>")<ESC>

" <Leader>[ Surround a word with [brackets]
map <Leader>] ysiw]
map <Leader>[ ysiw[
vmap <Leader>[ c[ <C-R>" ]<ESC>
vmap <Leader>] c[<C-R>"]<ESC>

" <Leader>{ Surround a word with {braces}
map <Leader>} ysiw}
map <Leader>{ ysiw{
vmap <Leader>} c{ <C-R>" }<ESC>
vmap <Leader>{ c{<C-R>"}<ESC>

map <Leader>> ysiw>
map <Leader>< ysiw<
vmap <Leader>> c<<C-R>"><ESC>
vmap <Leader>< c<<C-R>"><ESC>

" Run {{{1
noremap <Leader>rr :w<cr>:call RunCurrentFile()<cr>
noremap <Leader>rm :MarkdownPreview<cr>
vnoremap <Leader>rl "xy:call netrw#NetrwBrowseX(@x, 0)<cr>
vnoremap <Leader>rs "9y:<c-r>9<cr>
noremap <Leader>rt :QuickShell build-ctags<cr>




" Git (v = version control) {{{1
noremap <Leader>vt :QuickShell tig<cr>
noremap <Leader>vs :QuickShell tig status<cr>
noremap <Leader>vrf :call Confirm("Revert current file?", "!git co %")<cr>
noremap <Leader>vrp :Git co -p %<cr>
noremap <Leader>vdf  :Git diff %<cr>
noremap <Leader>vdc  :Git diff --cached<cr>
noremap <Leader>vaf :Git add %<cr>
noremap <Leader>vap :Git add -p %<cr>
noremap <Leader>vh :Q tig %<cr>
noremap <Leader>vc :Gcommit<cr>

" Spaces text object {{{1
xnoremap <silent><space> f oT o
xnoremap <silent>a<space> f oF o
xnoremap <silent>i<space> t oT o
" Testing {{{1
noremap <Leader>tt :TestLast<cr>
"noremap <Leader>tl :call RunSpecLine()<cr>
noremap <Leader>tf :TestFile<cr>

" Toggle stuff {{{1
noremap <Leader>ti :IndentGuidesToggle<cr>
noremap <Leader>te :SyntasticToggleMode<cr>:redraw!<cr>
noremap <Leader>tb :call ToggleBackground()<cr>

" Post Startup {{{1
func! PostStartupKeys()
  vnoremap <tab> >gv
  vnoremap <s-tab> <gv
  vnoremap <space> 20j
endfunc

" Profiling {{{1

nnoremap <silent> <leader>PP :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>PQ :exe ":profile pause"<cr>:noautocmd qall!<cr>

" Java {{{1
nnoremap <leader>ji :JavaImport<cr>
nnoremap <leader>jm :JavaImpl<cr>
nnoremap <leader>jg :JavaGet<cr>
nnoremap <leader>js :JavaGetSet<cr>


" Misc {{{1
vnoremap ,s :!sort<cr>

" Tabs {{{1
noremap <m-.> gt
inoremap <m-.> <c-o>gt
tnoremap <m-.> <c-\><c-n>gt

noremap <m-,> gT
inoremap <m-,> <c-o>gT
tnoremap <m-,> <c-\><c-n>gT

" Oni {{{1

if exists('g:gui_oni')
  nnoremap Y 0vjy
end
