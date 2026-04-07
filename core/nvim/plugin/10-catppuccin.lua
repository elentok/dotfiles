-- local transparent = not vim.g.neovide
local transparent = false

local dim_inactive = {
  enabled = true,
  shade = "dark",
  percentage = 0.15,
}

if transparent then dim_inactive = nil end

---@module 'catppuccin'
---@type CatppuccinOptions
require("catppuccin").setup({
  transparent_background = transparent,
  flavour = "mocha",
  dim_inactive = dim_inactive,
  custom_highlights = function(colors)
    return {
      VertSplit = { fg = colors.surface2 },
      WinSeparator = { fg = colors.surface2 },
    }
  end,
})

vim.cmd.colorscheme("catppuccin")
