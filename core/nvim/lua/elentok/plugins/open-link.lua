return {
  "elentok/open-link.nvim",
  dev = true,
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
