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
      -- barbecue = {
      --   alt_background = true,
      -- },
      cmp = true,
      gitsigns = true,
      flash = true,
      mason = true,
      navic = true,
      markdown = true,
      which_key = true,
      telescope = false,
      treesitter = true,
      fidget = true,
      neogit = true,
      nvim_surround = true,
      grug_far = true,
      -- dropbar = {
      --   enabled = true,
      --   color_mode = true,
      -- },
      indent_blankline = true,
      render_markdown = true,
      native_lsp = true,
    },
    custom_highlights = function(colors)
      return {
        VertSplit = { fg = colors.surface2 },
        WinSeparator = { fg = colors.surface2 },

        -- for some reason quotes appear in red, this changes them to light gray
        RenderMarkdownQuote = { fg = colors.subtext0 },
        ["@markup.quote"] = { fg = colors.subtext0 },
      }
    end,
  },
}
