return {
  -- Togglr
  {
    "elentok/togglr.nvim",
    opts = {},
    keys = {
      { "<leader>tw" },
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

  -- Open Link
  {
    "elentok/open-link.nvim",
    lazy = false,
    config = function()
      local expanders = require("open-link.expanders")
      require("open-link").setup({
        expanders = {
          expanders.homedir(),
          expanders.github,
          expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),
        },
      })
    end,
    keys = {
      {
        "<Leader>ip",
        "<cmd>PasteImage<cr>",
        desc = "Paste image from clipboard",
      },
    },
  },
}
