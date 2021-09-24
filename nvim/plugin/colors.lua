if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

vim.o.background = "dark"

local lush = require("lush")
local colors = require("codeschool").setup({
  plugins = {
    "fzf", "lsp", "lspsaga", "neogit", "signify", "telescope", "treesitter"
  }
})
lush(colors)

-- Status + vertical split colors
vim.cmd([[
  hi StatusLine guibg=#126888 guifg=white gui=NONE
  hi VertSplit guifg=#126888
]])
-- hi StatusLineNC guibg=#003455
