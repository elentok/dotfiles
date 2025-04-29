local ai = require("elentok.lib.ai")

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  config = true,
  cond = ai.allow,
}
