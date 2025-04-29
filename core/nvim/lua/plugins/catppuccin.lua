return {
  "catppuccin/nvim",
  name = "catppuccin",
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
  init = function()
    vim.cmd("colorscheme catppuccin")
  end,
}
