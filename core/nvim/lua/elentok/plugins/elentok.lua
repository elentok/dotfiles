return {
  -- Togglr
  {
    "elentok/togglr.nvim",
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
    opts = {},
    cmd = { "Scriptify" },
    keys = {
      { "<leader>sf", "<Cmd>Scriptify<cr>", desc = "Scriptify" },
    },
  },

  -- Encrypt
  {
    "elentok/encrypt.nvim",
    opts = {},
  },
}
