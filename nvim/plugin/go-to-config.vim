function! GoToConfig(file)
  exec "e $DOTF/nvim/" . a:file
endfunction

command! -complete=dir -nargs=+ GoToConfig call GoToConfig("<args>")

command! FZFConfig call fzf#run({
      \ "source": "nvim-list-config",
      \ "window": "call FloatingFZF()",
      \ "options": "--prompt 'Config> '",
      \ "sink": 'GoToConfig'})

noremap <Leader>gc :FZFConfig<cr>
