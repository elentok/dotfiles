function! s:GitLogHandler(job_id, data, event) dict
  for line in a:data
    if line != ''
      if strlen(getline(line('$'))) == ''
        call setline(line('$'), line)
      else
        call append(line('$'), line)
      endif
    endif
  endfor
endfunction

function! GitLog()
  vnew
  setlocal buftype=nofile cursorline
  let format = "format:%h -%d %s <%cr by %an>"
  let command = ['git', 'log', '--graph', '--pretty=' . format]
  let job = jobstart(command, { 'on_stdout': function('s:GitLogHandler') })

  nnoremap <buffer> gy 0wyiw
  nnoremap <buffer> gf 0w"gyiw:Q git fix <c-r>g<cr>
endfunction

command! GitLog call GitLog()

cabbr Gca Gcommit --amend
cabbr Gps Git --paginate push
cabbr Gpl Git --paginate pull
cabbr Gap Git add -p
cabbr Gam Gcommit --amend
