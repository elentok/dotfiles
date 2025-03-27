---@module "lazy"
---@module "stuff"
---@type LazySpec
return {
  "elentok/stuff.nvim",
  dev = true,
  config = function()
    local expanders = require("stuff.open-link.expanders")
    require("stuff").setup({
      toggle_word = {},
      paste_image = true,
      git = true,
      open_link = {
        expanders = {
          expanders.homedir(),
          expanders.github,
          expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),
        },
      },
    })
  end,
  keys = {
    { "<leader>tw" },
    { "gx" },
    { "<leader>ga" },
    { "<leader>gr" },
    { "<leader>gu" },
    { "<leader>gw" },
    {
      "<Leader>ip",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from clipboard",
    },
  },
}
