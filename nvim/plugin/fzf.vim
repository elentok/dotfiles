" disable the preview window (I don't look it and it sometimes slows me down).
let g:fzf_preview_window = ''

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

if !exists('$FZF_DEFAULT_COMMAND')
  if g:os == 'windows'
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*"'
  else
    let $FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
  endif
endif

function! FZFEdit(prompt, source, ...)
  let sink = get(a:, 1, 'e')

  call fzf#run({
    \ "source": a:source,
    \ "window": g:fzf_layout['window'],
    \ "options": "--prompt '" . a:prompt . ">'",
    \ "sink": sink})
endfunction

command! FZFGitStaged call FZFEdit('Git Staged', 'git diff --name-only --cached')
command! FZFGitUnstaged call FZFEdit('Git Unstaged', 'git diff --name-only')
command! FZFGitChanged call FZFEdit('Git Changed', 'git diff --name-only HEAD')

command! FZFHgModified call FZFEdit('Hg Modified', 'hg status --no-status')
command! FZFHgUnresolved call FZFEdit('Hg Unresolved', "hg resolve --no-status --list 'set:unresolved()'")

" noremap <c-p> :Files<cr>
" noremap <Leader>b :Buffers<cr>
noremap <Leader>gm :FZFMru<cr>
" noremap <Leader>gt :Tags<cr>
noremap `` :BTags<cr>

noremap <Leader>vm :FZFGitChanged<cr>

nnoremap <Leader>hm :FZFHgModified<cr>
nnoremap <Leader>hu :FZFHgUnresolved<cr>
