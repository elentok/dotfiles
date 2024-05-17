local is_dev_mode = require("elentok.lib.dev-mode")

return {
  "elentok/open-link.nvim",
  dev = is_dev_mode,
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
  dependencies = {
    "ojroques/nvim-osc52",
  },
  keys = {
    {
      "<Leader>ip",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from clipboard",
    },
  },
}
