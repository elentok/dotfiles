return {
  "elentok/open-link.nvim",
  dev = true,
  opts = {
    addExpanders = {
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
}
