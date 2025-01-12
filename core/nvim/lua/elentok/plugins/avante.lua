return {
  "yetone/avante.nvim",
  -- event = "VeryLazy",
  -- lazy = true,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    provider = "copilot",
    copilot = {
      model = "claude-3.5-sonnet",
    },
  },
  cmd = {
    "AvanteAsk",
    "AvanteChat",
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.icons",
    "zbirenbaum/copilot.lua", -- for providers='copilot'
  },
}
