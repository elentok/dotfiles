command! BufClean :call DeleteHiddenBuffers()
command! WinOnly call WinOnly()

" Delete Hidden Buffers {{{1
" See http://stackoverflow.com/a/30101152
function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

" Close all windows in the tab except the active one (and nerdtree and
" terminals)
function! WinOnly()
  let current_buf_id = nvim_get_current_buf()
  let current_win_id = nvim_get_current_win()

  let closed = 0

  for win_id in nvim_tabpage_list_wins(nvim_get_current_tabpage())
    if win_id == current_win_id
      continue
    endif

    let buf_id = nvim_win_get_buf(win_id)
    let name = nvim_buf_get_name(buf_id)

    if name =~ "NERD_tree" || name =~ "^term://"
      continue
    endif

    let winnr = nvim_win_get_number(win_id)

    silent exec winnr . "wincmd c"
    let closed += 1
  endfor

  echo "Closed " . closed . " windows"
endfunction
