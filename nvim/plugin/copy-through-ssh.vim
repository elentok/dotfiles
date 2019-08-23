" These functions will run on the ssh server (not the client).
" On the client you need to start the clipboard listening server:
"
"   while (true); do nc -l 7777 | pbcopy; done
"
" Or:
"
"   daemon start clipboard clipboard-server

func! CopyThroughSSH() range
  normal gv"sy
  call system("nc -q0 localhost 7777", @s)
endfunc

vnoremap <Leader>ys :call CopyThroughSSH()<cr>
