return {
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
}
