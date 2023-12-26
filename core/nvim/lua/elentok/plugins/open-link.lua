local is_dev_mode = require('elentok.lib.dev-mode')

return {
  "elentok/open-link.nvim",
  dev = is_dev_mode,
  init = function()
    local expanders = require("open-link.expanders")
    require("open-link").setup({
      expanders = {
        expanders.homedir(),
        expanders.github,
        expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),
      },
    })
  end,
  dependencies = {
    "ojroques/nvim-osc52",
  },
  cmd = { "OpenLink", "PasteImage" },
  keys = {
    {
      "ge",
      "<cmd>OpenLink<cr>",
      desc = "Open the link under the cursor",
    },
    {
      "<Leader>ip",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from clipboard",
    },
  },
}
