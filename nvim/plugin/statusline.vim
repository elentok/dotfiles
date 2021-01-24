set statusline=
set statusline+=%{Elentok_StatusLineFileName()} " Path to the file in the buffer, as typed or relative to current directory
set statusline+=%< " Where to truncate line
set statusline+=%{&modified?'\ +':''}
set statusline+=%{&readonly?'\ ':''}
set statusline+=%= " Separation point between left and right aligned items
" set statusline+=%{gutentags#statusline()}
set statusline+=\ [%{''!=#&filetype?&filetype:'none'}]
set statusline+=\ %l:%v " Line number + column number

function! Elentok_StatusLineFileName()
  if exists('b:vaffle')
    return 'DIR: ' . b:vaffle['dir']
  endif

  let filename = expand('%:t')
  let path = substitute(expand('%:p:h'), getcwd(), '.', '')

  if path == '.'
    return filename
  endif

  return filename . ' (' . path . ')'
endfunction
