---@module "snacks"

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["@"] = "qflist",
          },
        },
      },
    },

    image = { enabled = true, markdown = { enabled = true } },
  },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
  keys = {
    {
      "<leader>w/",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep word",
    },
    {
      "``",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
    {
      "<leader>gh",
      function()
        Snacks.picker.git_log_file(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git history of current file",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log(require("stuff.snacks.git").git_commits_picker_config)
      end,
      desc = "Show git log",
    },
  },
}
