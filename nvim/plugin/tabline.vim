function! Elentok_TabLine()
  let s = ''
  let current_tab = tabpagenr() - 1
  for index in range(tabpagenr('$'))
    if index == current_tab
      let s .= '%#TabLineSel# '
    else
      let s .= '%#TabLine# '
    endif
    let s .= index . Elentok_TabText(index) . ' '
  endfor
  let s .= '%#TabLineFill#%T'
  return s
endfunction

function! Elentok_TabText(index)
  let buffers = tabpagebuflist(a:index + 1)
  let name = bufname(buffers[0])

  let text = ''
  if len(name) > 0
    let text .= ' ' . fnamemodify(name, ":t")
  endif

  if Elentok_IsTabModified(a:index)
    let text .= ' (+)'
  endif

  if len(text) > 0
    let text = ':' . text
  endif

  return text
endfunction

function! Elentok_IsTabModified(index)
  let buffers = tabpagebuflist(a:index + 1)
  for bufnr in buffers
    if getbufvar(bufnr, "&modified")
      return 1
    endif
  endfor
  return 0
endfunction

set tabline=%!Elentok_TabLine()
