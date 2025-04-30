vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.number = true
vim.o.relativenumber = true
vim.o.laststatus = 3
vim.o.wrap = false

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- When splitting vertically move the focus to the right window.
vim.o.splitright = true

vim.o.clipboard = "unnamedplus"

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  float = {
    border = "rounded",
  },
})
