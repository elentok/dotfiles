" vim: foldmethod=marker
" Commands {{{1
command! AutoWrap set formatoptions+=c formatoptions+=t
command! AutoWrapOff set formatoptions-=c formatoptions-=t
command! W :w

command! Eautocmds  edit ~/.dotfiles/vim/autocmds.vim
command! Eplugs     edit ~/.dotfiles/vim/plugs.vim
command! Efunctions edit ~/.dotfiles/vim/functions.vim
command! Ekeys      edit ~/.dotfiles/vim/keys.vim
command! Esettings  edit ~/.dotfiles/vim/settings.vim
command! Eabbr      edit ~/.dotfiles/vim/abbr.vim

command! -range=% NumberLines call NumberLines()
command! CSScomb call CSScomb()
command! -nargs=+ CSScolor call CSScolor("<args>")

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

" revert {{{1
func! RevertFile()
  if &modified
    call Confirm("Revert unsaved changes?", "e!")
  else
    e!
  end
endfunc

" format ruby object {{{1
func! FormatRubyObject()
  while stridx(getline('.'), ',') != -1
    exec "normal! 0f,lr\<cr>"
  endwhile
endfunc

command! -range FormatRubyObject call FormatRubyObject()

" preview sass colors {{{1
command! PreviewSassColors !preview_sass_colors % && open preview.html

" js2coffee {{{1
func! Js2Coffee()
  silent! %s/\s\+$//
  silent! %s/; *$//
  silent! %s/\v[A-Za-z_]+\.prototype\.([a-zA-Z_]+) *\= *function\s*\(\) *\{/\1: ->/gc
  silent! %s/\v[A-Za-z_]+\.prototype\.([a-zA-Z_]+) *\= *function\s*(\(.*\)) *\{/\1: \2 ->/gc
  silent! %s/\v\s*function\s*\(\) *\{/\1 ->/gc
  silent! %s/\v\s*function\s*(\([^\)]*\)) *\{/\1 ->/gc
  silent! %s/this\./@/gc
  silent! %s/var //gc
  silent! %s/var //gc
  silent! %g/var //gc
  silent! %g/^\s*}\s*$/d
endfunc

" Scriptify {{{1
let g:hash_tags = {
  \ 'python': '#!/usr/bin/env python',
  \ 'ruby': '#!/usr/bin/env ruby',
  \ 'bash': '#!/bin/bash'
  \}

func! Scriptify(lang)
  exec "normal ggO" . g:hash_tags[a:lang] . "\n"
  write
  call system('chmod u+x ' . shellescape(expand('%')))
  e!
endfunc

func! ScriptifyValues(ArgLead, CmdLine, CursorPos)
  return keys(g:hash_tags)
endfunc

command! -nargs=1 -complete=customlist,ScriptifyValues Scriptify call Scriptify("<args>")

" Escaped search {{{1
func! EscapeForQuery(text)
  let text = substitute(a:text, '\v(\[|\]|\$|\^)', '\\\1', 'g')
  let text = substitute(text, "'", "''", 'g')
  return text
endfunc

func! EscapeRegisterForQuery(register)
  return EscapeForQuery(getreg(a:register))
endfunc

" FocusMode {{{1
function! ToggleFocusMode()
  if (&foldcolumn != 12)
    set laststatus=0
    set numberwidth=10
    set foldcolumn=12
    set noruler
    hi FoldColumn ctermbg=none
    hi LineNr ctermfg=0 ctermbg=none
    hi NonText ctermfg=0
  else
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    execute 'colorscheme ' . g:colors_name
  endif
endfunc
nnoremap <Leader>td :call ToggleFocusMode()<cr>

" IndentFoldExpr {{{1
function! IndentFoldExpr(lnum)
  let line = getline(a:lnum)
  if line =~ '\v^ *$'
    return '='
  endif

  let expr = '='
  let level = strlen(matchstr(line, '\v^ *'))

  let next_lnum = GetNextNonEmptyLine(a:lnum)
  if next_lnum != -1
    let next_line = getline(next_lnum)
    let next_level = strlen(matchstr(next_line, '\v^ *'))
    if next_level > level
      let expr = 'a' . (next_level - level) / &tabstop
    elseif level > next_level
      let expr = 's' . (level - next_level) / &tabstop
    endif
  endif
  return expr
endfunc

function! GetNextNonEmptyLine(lnum)
  let lnum = a:lnum
  while lnum < line('$')
    let lnum = lnum + 1
    let line = getline(lnum)
    if line !~ '\v^ *$'
      return lnum
    endif
  endwhile
  return -1
endfunc

" Background {{{1
function! ToggleBackground()
  if &background == "dark"
    set background=light
  else
    set background=dark
  endif
  call writefile(["set background=" . &background], expand("~/.vimstate"))
endfunc

" Number Lines {{{1
function! NumberLines()
  let i = line('.') - a:firstline + 1
  exec "s/^/" . i .". /"
endfunc

" CSSComb {{{1

function! CSScomb()
  let csscomb_root = $BREW_HOME . '/lib/node_modules/csscomb'
  let config = csscomb_root . '/config/zen.json'
  execute "silent !csscomb -c " . config . " " . expand('%')
  redraw!
endfunction

function! CSScolor(color)
  let format="sass"
  if &filetype == "less"
    let format="less"
  endif
  let css=system("color2css.py " . a:color . " --format " . format)
  let @c=css
  normal "cp
endfunction

" OnSave {{{1

function! OnSave(cmd)
  augroup Elentok_OnSave
    autocmd!
    if a:cmd == ""
      echo "OnSave OFF" 
    else
      echo "OnSave: " . a:cmd
      exec "autocmd BufWritePost * " . a:cmd
    endif
  augroup END
endfunction

command! -nargs=* OnSave call OnSave("<args>")

" Exec {{{1
if has('nvim')
  function! QuickShell(cmd)
    let cmd=substitute(a:cmd, '%', '"' . expand('%') . '"', 'g')
    vsplit
    exec "terminal " . cmd
  endfunction

  command! -nargs=+ QuickShell call QuickShell("<args>")
else
  command! -nargs=+ QuickShell !<args>
end

