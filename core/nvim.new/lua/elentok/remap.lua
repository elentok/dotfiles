vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "<c-s>", ":w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")
vim.keymap.set("n", "<space>u", vim.cmd.UndotreeToggle)
