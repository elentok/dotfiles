if exists('*nvim_create_buf')
  let $FZF_DEFAULT_OPTS='--layout=reverse --margin=1,2,1,2'
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  function! FloatingFZF()
    let buf = nvim_create_buf(v:false, v:true)

    let height = &lines / 2
    let width = float2nr(&columns - (&columns * 1 / 4))
    let col = float2nr((&columns - width) / 2)

    let opts = {
          \ 'relative': 'editor',
          \ 'row': &lines / 5,
          \ 'col': col,
          \ 'width': width,
          \ 'height': height
          \ }

    let win = nvim_open_win(buf, v:true, opts)
    call setwinvar(win, '&signcolumn', 'no')
  endfunction
endif
