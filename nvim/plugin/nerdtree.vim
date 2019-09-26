let NERDTreeIgnore=['\.zeus\.sock$', '\~$', '^node_modules$']
let NERDTreeHijackNetrw = 0

if !empty($DISABLE_UNICODE)
  let g:NERDTreeDirArrows = 1
  let g:NERDTreeDirArrowCollapsible = 'v'
  let g:NERDTreeDirArrowExpandable = '>'
endif
