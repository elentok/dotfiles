local is_dev_mode = require('elentok.lib.dev-mode')

return {
  -- Togglr
  {
    "elentok/togglr.nvim",
    dev = is_dev_mode,
    opts = {
      key = false,
    },
    keys = {
      {
        "<leader>tw",
        function()
          require("togglr").toggle_word()
        end,
        desc = "Toggle word",
      },
    },
  },

  -- Scriptify
  {
    "elentok/scriptify.nvim",
    dev = is_dev_mode,
    opts = {},
    cmd = { "Scriptify" },
  },
}
