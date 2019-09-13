" vim: foldmethod=marker
" Commands {{{1
command! AutoWrap set formatoptions+=c formatoptions+=t
command! AutoWrapOff set formatoptions-=c formatoptions-=t
command! W :w

command! Eautocmds  edit ~/.dotfiles/nvim/autocmds.vim
command! Eplugs     edit ~/.dotfiles/nvim/plugs.vim
command! Esettings  edit ~/.dotfiles/nvim/settings.vim
command! Eabbr      edit ~/.dotfiles/nvim/abbr.vim
command! Ealiases   edit ~/.dotfiles/zsh/aliases.sh

command! -nargs=+ Ewhich     exec "edit " . system("which <args>")
command! -nargs=+ CSScolor call CSScolor("<args>")

command! SudoWrite :w !sudo tee %

" Remap <cr> in quickfix buffers {{{1
func! RemapCrInQuickFixBuffers()
  if &buftype == 'quickfix'
    nnoremap <buffer> <cr> <cr>
  end
endfunc

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


" fix nerdtree width {{{1
function! FixNERDTreeWidth()
  let winwidth = winwidth(".")
  if winwidth < g:NERDTreeWinSize
    exec("silent vertical resize " . g:NERDTreeWinSize)
  endif
endfunc

" confirm hazardus command() {{{1
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


" preview sass colors {{{1
command! PreviewSassColors !preview_sass_colors % && open preview.html

" Escaped search {{{1
func! EscapeForQuery(text)
  let text = substitute(a:text, '\v(\[|\]|\$|\^)', '\\\1', 'g')
  let text = substitute(text, "'", "''", 'g')
  return text
endfunc

func! EscapeRegisterForQuery(register)
  return EscapeForQuery(getreg(a:register))
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


" CSSColor {{{1

function! CSScolor(color)
  let format="sass"
  if &filetype == "less"
    let format="less"
  endif
  let css=system("color2css.py " . a:color . " --format " . format)
  let @c=css
  normal "cp
endfunction

" Exec {{{1
if has('nvim')
  function! QuickShell(cmd)
    if bufname('%') != ''
      tabe %
    else
      tabe
    endif
    execute 'terminal' a:cmd
  endfunction

  command! -nargs=+ QuickShell call QuickShell("<args>")
else
  command! -nargs=+ QuickShell !<args>
end

" Markserv {{{1
function! Markserv()
  QuickShell('markserv')
  tabprevious
  exec 'silent !o "http://localhost:8642/%"'
endfunction
command! Markserv call Markserv()

