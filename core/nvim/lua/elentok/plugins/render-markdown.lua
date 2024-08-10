return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    heading = {
      -- icons = { "󰬺 ", "󰬻 ", "󰬼 ", "󰬽 ", "󰬾 ", "󰬿 " },
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      sign = false,
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
      },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}

-- vim.api.nvim_set_hl()

-- ObsidianInProgress = { fg = "#EBCB8B" },
-- ObsidianWaiting = { fg = "#C27D00" },
-- ObsidianDone = { fg = "#6C7A96", bold = false },
