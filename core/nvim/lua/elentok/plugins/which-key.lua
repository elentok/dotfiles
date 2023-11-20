return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local wk = require("which-key")

    wk.register({
      j = {
        name = "jump",
      },
      f = {
        name = "find",
      },
      g = {
        name = "git",
      },
      o = {
        name = "open",
      },
      t = {
        name = "toggle/test",
      },
    }, { prefix = "<leader>" })
  end,
  opts = {},
}
