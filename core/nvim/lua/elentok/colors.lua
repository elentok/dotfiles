local util = require("elentok/util")

if vim.fn.has("termguicolors") then
  vim.o.termguicolors = true
end

vim.o.background = "dark"

local onedarkpro = util.safe_require("onedarkpro")
if onedarkpro then
  onedarkpro.setup({
    styles = { comments = "italic" },
    options = { cursorline = true },
  })
  onedarkpro.load()
end

-- Status + vertical split colors
vim.cmd([[
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
