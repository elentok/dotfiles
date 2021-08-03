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

command! FZFHgModified call FZFEdit('Hg Modified', 'hg status --no-status')

noremap `` :BTags<cr>
