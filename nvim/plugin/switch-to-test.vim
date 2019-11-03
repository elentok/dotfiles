map <Leader>go :call ToggleBetweenCodeAndTest()<cr>

function! ToggleBetweenCodeAndTest()
  let alternate = FindAlternateFile()
  if alternate != ''
    execute "edit " . alternate
  else
    echo 'Could not find alternate file'
  endif
endfunction

function! FindAlternateFile()
  let filename = expand("%")
  if matchstr(filename, '\v[._](test|spec)\.') != ''
    let alternate = substitute(filename, '\v[._](test|spec)\.', '.', '')
    if file_readable(alternate)
      return alternate
    endif
  else
    return FindTestFile()
  endif
endfunction

function! FindTestFile()
  let ext = expand('%:e')
  let without_ext = expand('%:r')

  for suffix in ['.test', '.spec', '_test', '_spec']
    let alternate = without_ext . suffix . '.' . ext
    if file_readable(alternate)
      return alternate
    endif
  endfor
endfunction
