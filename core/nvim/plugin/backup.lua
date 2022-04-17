local backupdir = vim.fn.expand("$HOME/.local/share/vim-backup")
local dir = vim.fn.expand("$HOME/.local/share/vim-swap")

vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = backupdir
vim.opt.dir = dir

if not vim.fn.isdirectory(backupdir) then
  vim.fn.mkdir(backupdir, "p")
end

if not vim.fn.isdirectory(dir) then
  vim.fn.mkdir(dir, "p")
end
