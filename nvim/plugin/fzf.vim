" disable the preview window (I don't look it and it sometimes slows me down).
let g:fzf_preview_window = ''

if !exists('$FZF_DEFAULT_COMMAND')
  if g:os == 'windows'
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*"'
  else
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
  endif
endif

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

noremap <c-p> :Files<cr>
noremap <Leader>b :Buffers<cr>
noremap <Leader>gm :FZFMru<cr>
noremap <Leader>gt :Tags<cr>
noremap `` :BTags<cr>
