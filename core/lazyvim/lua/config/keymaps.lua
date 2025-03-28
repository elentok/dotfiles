-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "i" }, "jk", "<esc>")

-- Inspired by Helix
vim.keymap.set({ "n", "v" }, "gh", "0", { desc = "Go to beginning of the line" })
vim.keymap.set({ "n", "v" }, "ge", "G", { desc = "Go to end of the file" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to end of the line" })
vim.keymap.set({ "n", "v" }, "gs", "_", { desc = "Go to first non-blank character" })

-- Map <leader>n and <leader>p to [ and ] to make it easier to use unimpaired
-- mappings without [ and ]
-- vim.keymap.set({ "n", "v" }, "<leader>p", "[", { remap = true })
-- vim.keymap.set({ "n", "v" }, "<leader>n", "]", { remap = true })

vim.keymap.set({ "n", "v" }, "<leader>vv", "<c-v>", { desc = "Go into block visual mode" })
vim.keymap.set("n", "vv", "V", { desc = "Go into visual line mode" })
vim.keymap.set("n", "vb", "<c-v>", { desc = "Go into visual block mode" })

vim.keymap.set("n", "<c-l>", function()
  require("tmux").move_right()
end)

vim.keymap.set("n", "<c-h>", function()
  require("tmux").move_left()
end)

vim.keymap.set("n", "<c-k>", function()
  require("tmux").move_top()
end)

vim.keymap.set("n", "<c-j>", function()
  require("tmux").move_bottom()
end)

vim.keymap.set("n", "<leader>yf", ':let @+ = expand("%:.")<cr>', { desc = "Yank current filename" })
vim.keymap.set("n", "<leader>wa", ":wa<cr>", { desc = ":wa" })
