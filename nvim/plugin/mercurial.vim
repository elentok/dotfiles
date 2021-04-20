command! FZFHgModified call FZFEdit('Hg Modified', 'hg status --no-status')
command! FZFHgUnresolved call FZFEdit('Hg Unresolved', "hg resolve --no-status --list 'set:unresolved()'")

command! HgResolve QuickShell hg resolve --mark %

nnoremap <Leader>hm :FZFHgModified<cr>
nnoremap <Leader>hu :FZFHgUnresolved<cr>
