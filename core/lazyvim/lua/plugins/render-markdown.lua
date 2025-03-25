return {
  "MeanderingProgrammer/render-markdown.nvim",
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
      },
      custom = {
        in_progress = {
          raw = "[/]",
          rendered = "󰪠",
        },
        waiting = {
          raw = "[w]",
          rendered = "󰏦",
        },
        code_review = {
          raw = "[r]",
          rendered = "",
        },
      },
    },
  },
}
