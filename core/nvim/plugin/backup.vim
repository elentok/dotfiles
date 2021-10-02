set backup writebackup
set backupdir=$HOME/.local/share/vim-backup
set dir=$HOME/.local/share/vim-swap

if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
end

if !isdirectory(&dir)
  call mkdir(&dir, "p")
end
