if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

vim.o.background = "dark"

vim.g.onedark_style = "warm"
require("onedark").setup()
vim.cmd("colorscheme onedark")

-- Status + vertical split colors
vim.cmd([[
  hi StatusLine guibg=#126888 guifg=white gui=NONE
  hi VertSplit guifg=#126888
]])
-- hi StatusLineNC guibg=#003455
