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

  {
    "elentok/format-on-save.nvim",
    dev = true,
  },

  {
    "elentok/open-link.nvim",
    dev = true,
    opts = {
      expanders = {
        {
          pattern = "^github-",
          replacement = "https://github.com/",
        },
        {
          pattern = "^format-on-save#",
          replacement = "https://github.com/elentok/format-on-save.nvim/pull/",
        },
      },
    },
    dependencies = {
      "ojroques/nvim-osc52",
    },
    cmd = { "OpenLink" },
    keys = {
      {
        "ge",
        function()
          require("open-link").open()
        end,
        desc = "Open the link under the cursor",
      },
    },
  },
}
