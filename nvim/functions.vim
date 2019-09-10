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
command! BufClean :call DeleteHiddenBuffers()

command! FZFMru call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x +s',
\  'down':    '40%'})

command! FZFGitStaged call fzf#run({
      \ "source": "git diff --name-only --cached",
      \ "options": "--prompt 'Git Staged>'",
      \ "sink": "e"})

command! FZFGitUnstaged call fzf#run({
      \ "source": "git diff --name-only",
      \ "options": "--prompt 'Git Unstaged>'",
      \ "sink": "e"})

command! FZFGitChanged call fzf#run({
      \ "source": "git diff --name-only HEAD",
      \ "options": "--prompt 'Git Changed>'",
      \ "sink": "e"})

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


" Scriptify {{{1
let g:hash_tags = {
  \ 'python': '#!/usr/bin/env python',
  \ 'ruby': '#!/usr/bin/env ruby',
  \ 'bash': '#!/usr/bin/env bash',
  \ 'node': '#!/usr/bin/env node'
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

" Delete Hidden Buffers {{{1
" See http://stackoverflow.com/a/30101152
function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

" Close all windows in the tab except the active one (and nerdtree and
" terminals)
function! WinOnly()
  let current_buf_id = nvim_get_current_buf()
  let current_win_id = nvim_get_current_win()

  let closed = 0

  for win_id in nvim_tabpage_list_wins(nvim_get_current_tabpage())
    if win_id == current_win_id
      continue
    endif

    let buf_id = nvim_win_get_buf(win_id)
    let name = nvim_buf_get_name(buf_id)

    if name =~ "NERD_tree" || name =~ "^term://"
      continue
    endif

    let winnr = nvim_win_get_number(win_id)

    silent exec winnr . "wincmd c"
    let closed += 1
  endfor

  echo "Closed " . closed . " windows"
endfunction

command! WinOnly call WinOnly()

" Markserv {{{1
function! Markserv()
  QuickShell('markserv')
  tabprevious
  exec 'silent !o "http://localhost:8642/%"'
endfunction
command! Markserv call Markserv()

" Misc {{{1
function! EscapeCurrentFileDir()
  let path = expand("%:p:h")
  let path = substitute(path, ' ', '\\ ', 'g')
  return path
endfunction
