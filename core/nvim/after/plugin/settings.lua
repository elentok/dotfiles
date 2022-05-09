vim.opt.wrap = false

vim.g.markdown_folding = true
vim.g.markdown_fenced_languages = {
  "vim",
  "lua",
  "typescript",
  "javascript",
  "python",
  "html",
  "css",
}

vim.opt.cursorline = true

vim.opt.foldlevel = 1
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.formatoptions = table.concat({
  "b", -- Auto-wrap only if not already longer than text width
  "t", -- Auto-wrap comments using text width
  "c", -- Auto-wrap text using text width
  "q", -- Allow formatting of comments with "gq"
  "r", -- Automatically insert comment leader after hitting <Enter>
  "o", -- Automatically insert comment leader after hitting 'o' or 'O'
  "n", -- Recognize numbered lists
})

-- vim-signify
-- vim.g.signify_sign_add = "▊" -- U+258A LEFT THREE QUARTERS BLOCK (1 cell)
-- vim.g.signify_sign_change = "██" -- U+2588 FULL BLOCK x2 (2 cells)

vim.opt.dictionary = "/usr/share/dict/american-english"

-- When splitting vertically move the focus to the right window.
vim.opt.splitright = true

-- Settings for the tversteeg/registers.nvim plugin.
vim.g.registers_window_border = "single"

vim.opt.expandtab = true

vim.opt.clipboard = { "unnamed", "unnamedplus" }
vim.opt.textwidth = 80

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = ">>"

vim.opt.list = true
vim.opt.listchars = "tab:»·,trail:·"

vim.opt.mouse = "a"
vim.opt.scrolloff = 3

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

-- Makes sure the active window will always be at least 80 characters.
vim.opt.winwidth = 84

vim.opt.foldtext = "getline(v:foldstart)"
