return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
  opts = {
    flavour = "macchiato",
    dim_inactive = {
      enabled = true,
      shade = "dark",
    },
    integrations = {
      barbecue = {
        alt_background = true,
      },
      cmp = true,
      gitsigns = true,
      flash = true,
      mason = true,
      navic = true,
      aerial = true,
      harpoon = true,
      markdown = true,
      which_key = true,
      telescope = true,
      treesitter = true,
      fidget = true,
    },
    custom_highlights = function(colors)
      return {
        VertSplit = { fg = colors.surface2 },
      }
    end,
  },
}
