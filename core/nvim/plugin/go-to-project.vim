function! Proj(dir)
  tabe
  exec "tcd " . a:dir
endfunction

command! -complete=dir -nargs=+ Proj call Proj("<args>")

command! FZFProj call fzf#run({
      \ "source": "list-projects",
      \ "options": "--prompt 'Project> '",
      \ "sink": 'Proj'})

noremap <Leader>gp :FZFProj<cr>
