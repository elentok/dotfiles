set statusline=
set statusline+=%{Elentok_StatusLineFileName()} " Path to the file in the buffer, as typed or relative to current directory
set statusline+=%< " Where to truncate line
set statusline+=%{&modified?'\ +':''}
set statusline+=%{&readonly?'\ ':''}
set statusline+=%= " Separation point between left and right aligned items
" set statusline+=%{gutentags#statusline()}
set statusline+=\ [%{''!=#&filetype?&filetype:'none'}]
set statusline+=\ %l:%v " Line number + column number

let g:statusline_shorteners = []

function! Elentok_AddPathShortener(full, short)
  call add(g:statusline_shorteners, [a:full, a:short])
  let g:statusline_shorteners_updated = 1
endfunction

call Elentok_AddPathShortener($HOME, '~')

function! Elentok_StatusLineFileName()
  if exists('b:vaffle')
    let short_path = statusline#shorten(b:vaffle['dir'])

    return 'DIR: ' . short_path
  endif

  " Temporary solution
  if exists('g:statusline_shorteners_updated')
    unlet g:statusline_shorteners_updated
    if exists('b:short_path')
      unlet b:short_path
    endif
  endif


  let filename = expand('%:t')

  if !exists('b:short_path')
    let b:short_path = statusline#shorten(expand('%:p:h'))
  endif

  return filename . ' (' . b:short_path . ')'
endfunction

function statusline#shorten(path)
  let path = a:path

  for [full, short] in g:statusline_shorteners
    let path = substitute(path, full . '\(/\|$\)', short . '\1', '')
  endfor

  return path
endfunction
