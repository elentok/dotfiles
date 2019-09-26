if !exists('$FZF_DEFAULT_COMMAND')
  if g:os == 'windows'
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*"'
  else
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
  endif
endif

command! FZFMru call fzf#run({
      \  "source":  v:oldfiles,
      \  "sink":    "e",
      \  "window": "call FloatingFZF()",
      \  "options": "-m -x +s",
      \  "down":    "40%"})

command! FZFGitStaged call fzf#run({
      \ "source": "git diff --name-only --cached",
      \ "options": "--prompt 'Git Staged>'",
      \ "window": "call FloatingFZF()",
      \ "sink": "e"})

command! FZFGitUnstaged call fzf#run({
      \ "source": "git diff --name-only",
      \ "options": "--prompt 'Git Unstaged>'",
      \ "window": "call FloatingFZF()",
      \ "sink": "e"})

command! FZFGitChanged call fzf#run({
      \ "source": "git diff --name-only HEAD",
      \ "options": "--prompt 'Git Changed>'",
      \ "window": "call FloatingFZF()",
      \ "sink": "e"})
