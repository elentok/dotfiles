if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

vim.o.background = "dark"

-- Sonokai colorscheme
vim.g.sonokai_style = "andromeda"
vim.cmd("silent! colorscheme sonokai")

-- Status + vertical split colors
vim.cmd([[
  hi StatusLine guibg=#126888
  hi StatusLineNC guibg=#003455
  hi VertSplit guifg=#126888
]])
