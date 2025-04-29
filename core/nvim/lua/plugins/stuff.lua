---@module "lazy"
---@module "stuff"
---@type LazySpec
return {
  "elentok/stuff.nvim",
  dev = true,
  lazy = false,
  config = function()
    local expanders = require("stuff.open-link.expanders")
    require("stuff").setup({
      open_link = {
        expanders = {
          expanders.homedir(),
          expanders.github,
          expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),
        },
      },
    })
  end,
}
