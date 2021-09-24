vim.g.markdown_folding = true

vim.opt.foldlevel = 1

vim.opt.formatoptions = table.concat({
  "b", -- Auto-wrap only if not already longer than text width
  "t", -- Auto-wrap comments using text width
  "c", -- Auto-wrap text using text width
  "q", -- Allow formatting of comments with "gq"
  "r", -- Automatically insert comment leader after hitting <Enter>
  "o", -- Automatically insert comment leader after hitting 'o' or 'O'
  "n" -- Recognize numbered lists
})

-- vim-signify
vim.g.signify_sign_add = "▊" -- U+258A LEFT THREE QUARTERS BLOCK (1 cell)
vim.g.signify_sign_change = "██" -- U+2588 FULL BLOCK x2 (2 cells)
