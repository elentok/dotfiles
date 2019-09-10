command! FoldByIndent setlocal foldmethod=expr nofoldenable
  \ foldexpr=IndentFoldExpr(v:lnum)

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
