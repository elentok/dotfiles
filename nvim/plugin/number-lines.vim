function! NumberLines()
  let i = line('.') - a:firstline + 1
  exec "s/^/" . i .". /"
endfunc

command! -range=% NumberLines call NumberLines()
