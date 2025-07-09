vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.laststatus = 3
vim.o.wrap = false
vim.o.linebreak = true

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Show hidden characters
vim.o.list = true

-- When splitting vertically move the focus to the right window.
vim.o.splitright = true

vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  float = {
    border = "rounded",
  },
})

-- Backup dir
local backupdir = vim.fn.stdpath("state") .. "/backup"
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = backupdir
if not vim.fn.isdirectory(backupdir) then vim.fn.mkdir(backupdir, "p") end
