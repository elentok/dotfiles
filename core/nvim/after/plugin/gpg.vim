" See http://www.futurile.net/2017/05/14/editing-encrypting-files-with-gnupg-vim/

" Armor files
let g:GPGPreferArmor=1
let g:GPGDefaultRecipients=["3david@gmail.com"]

" Lock file after 30 seconds of no use
augroup GPG
    autocmd!
    autocmd BufRead,BufEnter *.\(gpg\|asc\|pgp\) setlocal updatetime=30000
    autocmd CursorHold *.\(gpg\|asc\|pgp\) quit
augroup END
