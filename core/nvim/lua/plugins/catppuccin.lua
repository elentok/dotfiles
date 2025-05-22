local transparent = not vim.g.neovide

local dim_inactive = {
  enabled = true,
  shade = "dark",
  percentage = 0.15,
}

if transparent then dim_inactive = nil end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    transparent_background = transparent,
    flavour = "mocha",
    dim_inactive = dim_inactive,
    custom_highlights = function(colors)
      return {
        VertSplit = { fg = colors.surface2 },
        WinSeparator = { fg = colors.surface2 },
      }
    end,
  },
  init = function() vim.cmd("colorscheme catppuccin") end,
}
