function! GoToConfig(file)
  exec "e ~/" . a:file
endfunction

command! -complete=dir -nargs=+ GoToConfig call GoToConfig("<args>")

command! FZFConfig call FZFEdit('Config', 'nvim-list-config', 'GoToConfig')

noremap <Leader>gc :FZFConfig<cr>
