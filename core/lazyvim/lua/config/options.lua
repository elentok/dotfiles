-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

vim.g.lazyvim_eslint_auto_format = false

vim.opt.splitkeep = "cursor"

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
