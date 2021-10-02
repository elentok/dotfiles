noremap <Leader>tcd :TabCdToBufRoot<cr>
noremap <Leader>cd :CdToBufRoot<cr>

command! TabCdToBufRoot call TabCdToBufRoot()
command! CdToBufRoot call CdToBufRoot()

function! BufGetRoot()
  return systemlist("git-root '" . expand("%") . "'")[0]
endfunction

function! CdToBufRoot()
  let root = BufGetRoot()
  exec "cd " . root
  echomsg "Changed directory to: " . root
endfunction

function! TabCdToBufRoot()
  let root = BufGetRoot()
  exec "tcd " . root
  echomsg "Changed tab directory to: " . root
endfunction
