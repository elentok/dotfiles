func! ToggleHebrew()
  if &rl
    set norl
    set keymap=
  else
    set rl
    set keymap=hebrew
  end
endfunc

noremap <c-_> :call ToggleHebrew()<cr>
inoremap <c-_> <c-o>:call ToggleHebrew()<cr>
