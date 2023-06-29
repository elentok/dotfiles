-- Separate column for git signs so it doesn't override the line numbers
vim.opt.signcolumn = "yes"

local gitsigns = require("gitsigns")

gitsigns.setup({})

vim.keymap.set("n", "<space>b", function()
  gitsigns.blame_line({ full = true })
end)
vim.keymap.set("n", "<space>gs", ":Gitsigns<cr>")
vim.keymap.set("n", "<space>gp", ":Gitsigns preview_hunk<cr>")
vim.keymap.set("n", "<space>gi", ":Gitsigns preview_hunk_inline<cr>")
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<cr>")
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<cr>")

-- Text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
