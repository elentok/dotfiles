return {
  -- Togglr
  {
    "elentok/togglr.nvim",
    dev = true,
    opts = {
      key = false,
    },
    keys = {
      {
        "<space>tw",
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
    dev = true,
    opts = {},
    cmd = { "Scriptify" },
  },
}
