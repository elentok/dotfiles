---@module "stuff"

local expanders = require("stuff.open-link.expanders")
require("stuff").setup({
  terminal = false,
  open_link = {
    expanders = {
      expanders.homedir(),
      expanders.github,
      expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),
    },
  },
})
