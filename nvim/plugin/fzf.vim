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
