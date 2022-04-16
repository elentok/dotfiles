" vim: foldmethod=marker
" Google Search {{{1

func! WebSearch(url)
  let searchterm = input('Search: ', expand("<cword>"))
  if searchterm != ''
    let url = substitute(a:url, "%query%", searchterm, '')
    call Browse(url)
  end
endfunc

func! Browse(url)
  let opener='open'
  if has('linux')
    let opener='/usr/bin/xdg-open'
  end

  if has('gui_win32')
    call system("start " . a:url)
  else
    call system(opener . " '" . a:url . "' &")
  end
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

" preview sass colors {{{1
command! PreviewSassColors !preview_sass_colors % && open preview.html

" Markserv {{{1
function! Markserv()
  QuickShell('markserv')
  tabprevious
  exec 'silent !o "http://localhost:8642/%"'
endfunction
command! Markserv call Markserv()
