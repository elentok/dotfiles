---@module 'render-markdown'

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  opts = {
    ---@type render.md.UserConfig
    bullet = {
      icons = { " " },
    },
    checkbox = {
      enabled = true,
      unchecked = {
        icon = "󱓼",
      },
      checked = {
        icon = "󰄬",
        highlight = "NonText",
        scope_highlight = "NonText",
      },
      custom = {
        in_progress = {
          raw = "[/]",
          rendered = "󰪠",
          highlight = "NeogitGraphYellow",
          scope_highlight = "NeogitGraphYellow",
        },
        waiting = {
          raw = "[w]",
          rendered = "󰏦",
          highlight = "MiniIconsOrange",
          scope_highlight = "MiniIconsOrange",
        },
        code_review = {
          raw = "[r]",
          rendered = "",
          highlight = "MiniIconsPurple",
          scope_highlight = "MiniIconsPurple",
        },
      },
    },
    code = {
      border = "thin",
      sign = false,
    },
    heading = {
      sign = false,
    },
  },
}
