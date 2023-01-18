function! OnSave(cmd)
  augroup Elentok_OnSave
    autocmd!
    if a:cmd == ""
      echo "OnSave OFF" 
    else
      echo "OnSave: " . a:cmd
      exec "autocmd BufWritePost * " . a:cmd
    endif
  augroup END
endfunction

command! -nargs=* OnSave call OnSave("<args>")
