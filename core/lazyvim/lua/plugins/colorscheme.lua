return {
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      custom_highlights = function(colors)
        return {
          VertSplit = { fg = colors.surface2 },
          WinSeparator = { fg = colors.surface2 },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
