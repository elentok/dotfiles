---@module 'render-markdown'

vim.api.nvim_set_hl(0, "TaskDone", { fg = "#84b782", italic = true })
vim.api.nvim_set_hl(0, "TaskWaiting", { fg = "#aa6069", italic = true })

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  ---@type render.md.UserConfig
  opts = {
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
        highlight = "TaskDone",
        scope_highlight = "TaskDone",
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
          highlight = "TaskWaiting",
          scope_highlight = "TaskWaiting",
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
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 " },
    },
    pipe_table = {
      preset = "round",
    },
  },
}
