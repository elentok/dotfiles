-- Separate column for git signs so it doesn't override the line numbers
vim.opt.signcolumn = "yes"

require("gitsigns").setup({})

vim.keymap.set("n", "<space>b", ":Gitsigns blame_line<cr>")
vim.keymap.set("n", "<space>gs", ":Gitsigns<cr>")
vim.keymap.set("n", "<space>gp", ":Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "<space>gi", ":Gitsigns preview_hunk_inline<cr>")
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<cr>")
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<cr>")
