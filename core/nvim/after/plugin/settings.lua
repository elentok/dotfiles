vim.g.markdown_folding = true
vim.g.markdown_fenced_languages = {
  "vim", "lua", "typescript", "javascript", "python", "html", "css"
}

vim.opt.foldlevel = 1
vim.opt.relativenumber = true

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
-- vim.g.signify_sign_add = "▊" -- U+258A LEFT THREE QUARTERS BLOCK (1 cell)
-- vim.g.signify_sign_change = "██" -- U+2588 FULL BLOCK x2 (2 cells)

vim.opt.dictionary = "/usr/share/dict/american-english"

-- When splitting vertically move the focus to the right window.
vim.opt.splitright = true
