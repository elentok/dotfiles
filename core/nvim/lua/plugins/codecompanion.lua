---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    {
      "<leader>cc",
      function() require("codecompanion").actions() end,
      desc = "Code Companion",
    },
  },
}
