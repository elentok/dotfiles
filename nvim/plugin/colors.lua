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
  hi StatusLineNC guibg=#003455 gui=NONE
  hi VertSplit guifg=#126888
  hi Floaterm guibg=#1a1b1c
  hi FloatermBorder guibg=#1a1b1c

  hi TelescopeNormal guibg=#1a1b1c
  hi TelescopePreviewNormal guibg=#1a1b1c

  hi TelescopeBorder guibg=#1a1b1c
  hi TelescopePromptBorder guibg=#1a1b1c
  hi TelescopeResultsBorder guibg=#1a1b1c
  hi TelescopePreviewBorder guibg=#1a1b1c
]])
