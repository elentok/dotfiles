-- Separate column for git signs so it doesn't override the line numbers
vim.opt.signcolumn = "yes"

local gitsigns = require("gitsigns")

gitsigns.setup({})

vim.keymap.set("n", "<space>b", function()
  gitsigns.blame_line({ full = true })
end, { desc = "Git blame (current line)" })
vim.keymap.set("n", "<space>gs", ":Gitsigns<cr>", { desc = "Git signs menu" })
vim.keymap.set("n", "<space>gp", ":Gitsigns preview_hunk<cr>", { desc = "Git preview hunk" })
vim.keymap.set(
  "n",
  "<space>gi",
  ":Gitsigns preview_hunk_inline<cr>",
  { desc = "Git preview hunk (inline)" }
)
vim.keymap.set("n", "[c", ":Gitsigns prev_hunk<cr>", { desc = "Prev git hunk" })
vim.keymap.set("n", "]c", ":Gitsigns next_hunk<cr>", { desc = "Next git hunk" })

-- Text object
vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
