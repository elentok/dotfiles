return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end,
  opts = {
    flavour = "mocha",
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.15,
    },
    term_colors = true,
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
      neogit = true,
      nvim_surround = true,
      grug_far = true,
      dropbar = {
        enabled = true,
        color_mode = true,
      },
      indent_blankline = true,
    },
    custom_highlights = function(colors)
      return {
        VertSplit = { fg = colors.surface2 },
        WinSeparator = { fg = colors.surface2 },
      }
    end,
  },
}
