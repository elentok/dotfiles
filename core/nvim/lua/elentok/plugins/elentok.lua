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
    dev = true,
    opts = {},
    cmd = { "Scriptify" },
  },
}
