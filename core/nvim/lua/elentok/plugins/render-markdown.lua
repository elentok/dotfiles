return {
  "MeanderingProgrammer/render-markdown.nvim",
  version = "*",
  opts = {
    heading = {
      -- icons = { "󰬺 ", "󰬻 ", "󰬼 ", "󰬽 ", "󰬾 ", "󰬿 " },
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      sign = false,
    },
    code = {
      sign = false,
      style = "normal",
      width = "block",
      left_pad = 1,
      right_pad = 1,
      position = "right",
      border = "thin",
    },
    checkbox = {
      unchecked = {
        icon = "󰄱",
      },
      checked = {
        icon = "",
      },
      custom = {
        waiting = {
          raw = "[w]",
          rendered = "⏸",
          highlight = "RenderMarkdownError",
        },
        in_progress = {
          raw = "[/]",
          rendered = "◧",
          highlight = "RenderMarkdownH5",
        },
        info = {
          raw = "[n]",
          rendered = "󰎚",
        },
      },
    },
    -- Fix a bug with the callouts where it shows the "]" after the rendered
    -- text (just added a space at the end)
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note " },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip " },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important " },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning " },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution " },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
