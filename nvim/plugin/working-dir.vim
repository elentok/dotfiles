function! TermSetWorkDir(dir)
  let b:working_dir = a:dir
  exec 'cd ' . b:working_dir
endfunction

function! SetBufferWorkingDirectory()
  if exists('b:working_dir') && b:working_dir != ''
    if exists('g:debug_autocd')
      echomsg 'AutoCD (cached): ' . b:working_dir
    endif
    exec 'cd ' . b:working_dir
    return
  endif

  if &filetype == 'fugitiveblame'
    return
  end

  if &buftype ==# 'terminal'
    return
  end

  if match(bufname(''), '^coc:.*') >= 0
    return
  end

  if !exists('b:working_dir')
    let b:working_dir = FindWorkingDirectory()
  endif

  if exists('g:debug_autocd')
    echomsg 'AutoCD: ' . b:working_dir
  endif

  exec 'cd ' . b:working_dir
endfunction

function! FindWorkingDirectory()
  let buffer_dir = expand('%:p:h')

  " remove '.git/*' suffix (git rev-parse doesn't work well inside the .git/ dir)
  let buffer_dir = substitute(buffer_dir, '\v/?\.git($|/.*$)', '', '')

  exec 'lcd ' . buffer_dir

  let git_dir = system('git rev-parse --show-toplevel')
  let is_git_dir = empty(matchstr(git_dir, '^fatal:.*'))
  if is_git_dir
    return git_dir
  endif

  return getcwd()
endfunction

" augroup Elentok_AutoWorkingDirectory
  " autocmd!
  " autocmd BufRead * call SetBufferWorkingDirectory()
  " autocmd WinEnter * call SetBufferWorkingDirectory()
" augroup END
