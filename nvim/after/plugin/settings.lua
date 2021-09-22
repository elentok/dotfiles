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
