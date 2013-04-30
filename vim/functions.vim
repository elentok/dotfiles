" vim: foldmethod=marker
" Commands {{{1
command! AutoWrap set formatoptions+=c formatoptions+=t
command! AutoWrapOff set formatoptions-=c formatoptions-=t
command! W :w

" Hebrew {{{1
func! ToggleHebrew()
  if &rl
    set norl
    set keymap=
  else
    set rl
    set keymap=hebrew
  end
endfunc

" Remap <cr> in quickfix buffers {{{1
func! RemapCrInQuickFixBuffers()
  if &buftype == 'quickfix'
    nnoremap <buffer> <cr> <cr>
  end
endfunc

" Autocompile coffeescript
func! CoffeeMake()
  if getline(1) =~ 'autocompile'
    silent make
    redraw!
    cw
  end
endfunc


" My Folding Expression {{{1
function! MyFoldingExpr(lnum)
    let line=getline(a:lnum)
    if line[0] == '*'
        if line[1] == '*'
            return '>2'
        else
            return '>1'
        endif
    else
        return '='
    endif
endfunction


" Google Search {{{1

func! WebSearch(url)
  let searchterm = input('Search: ', expand("<cword>"))
  if searchterm != ''
    let url = substitute(a:url, "%query%", searchterm, '')
    call Browse(url)
  end
endfunc

func! Browse(url)
  if has('gui_win32')
    call system("start " . a:url)
  else
    call system($opener . " '" . a:url . "' &")
  end
endfunc

" Calc {{{1

if has('python')
  :command! -nargs=+ Calc :py print <args>
  :py from math import *
end

" fix nerdtree width {{{1
function! FixNERDTreeWidth()
  let winwidth = winwidth(".")
  if winwidth < g:NERDTreeWinSize
    exec("silent vertical resize " . g:NERDTreeWinSize)
  endif
endfunc

" confirm hazardus command()
function! Confirm(message, command)
  let yesno = confirm(a:message, "&Yes\n&No", 2)
  if (yesno == 1)
    exec a:command
  else
    echo "User aborted"
  end
endfunc

" markdown {{{1
func! MarkdownPreview()
  w
  call system('marked ' . expand('%') . ' > /tmp/markdown-preview.html')
  call system('qlmanage -p /tmp/markdown-preview.html &')
endfunc

" toggle values {{{1


let g:alternate_words = {
      \ "true": "false",
      \ "True": "False",
      \ "false": "true",
      \ "False": "True",
      \ "should": "should_not",
      \ "should_not": "should",
      \ "be_true": "be_false",
      \ "be_false": "be_true",
      \ "yes": "no",
      \ "no": "yes",
      \ "left": "right",
      \ "right": "left",
      \ "border-left": "border-right",
      \ "border-right": "border-left",
      \ "border-top": "border-bottom",
      \ "border-bottom": "border-top"
      \}


func! ToggleWord()
  let word = expand("<cword>")
  if has_key(g:alternate_words, word)
    let word = g:alternate_words[word]
    exec "normal viwc" . word
  end
endfunc
