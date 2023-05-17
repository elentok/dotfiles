require("gitsigns").setup({})

vim.keymap.set("n", "<space>b", ":Gitsigns blame_line<cr>")
vim.keymap.set("n", "<space>g", ":Gitsigns<cr>")
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<cr>")
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<cr>")
