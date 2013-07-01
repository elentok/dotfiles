# By n0nick: https://gist.github.com/n0nick/67e930a32479d7b6b28a
# updated by @elentok

function replace-all -d "Replace all text in the given files"
  if test (count $argv) -lt 3
    echo "usage: replace-all old_text new_text paths ..."
    return 1
  end
 
  set old $argv[1]
  set new $argv[2]
  set files $argv[3..(count $argv)]

  set files (ag -l "$old" $files)

  if test (count $files) -eq 0
    echo "no matches found"
  else
    set leader_j 'nnoremap <leader>j :%s/'$old'/'$new'/gc<cr>'
    set leader_k 'nnoremap <leader>k :update\|:bd<cr>'
    vim -c "$leader_j" -c "$leader_k" $files
  end
end
