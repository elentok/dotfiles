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
