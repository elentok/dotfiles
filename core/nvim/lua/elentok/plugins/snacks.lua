local snacks_git = require("elentok.lib.snacks-git")
---@module "snacks"

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["@"] = "qflist",
          },
        },
      },
    },
    -- picker = { enabled = true, layout = { preset = "dropdown" } },
    quickfile = { enabled = true },
    image = { enabled = true, markdown = { enabled = true } },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
  keys = {
    {
      "<leader>f",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart find files",
    },
    {
      "<leader>jb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Jump to buffer",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      mode = { "n", "v" },
      desc = "Grep",
    },
    {
      "<leader>w/",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep word",
    },
    {
      "<leader>jh",
      function()
        Snacks.picker.help()
      end,
      desc = "Jump to help",
    },
    {
      "<leader>ll",
      function()
        Snacks.picker.lines()
      end,
      desc = "Find line",
    },
    {
      "z=",
      function()
        Snacks.picker.spelling()
      end,
      desc = "Fix spelling",
    },
    {
      "<leader>jj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jump to jump location",
    },
    {
      "<leader>jk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Jump to keymap",
    },
    {
      "<leader>jr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Jump to recent file",
    },
    {
      "<leader>jm",
      function()
        Snacks.picker.recent()
      end,
      desc = "Jump to recent file",
    },
    {
      "<leader>jg",
      function()
        Snacks.picker.git_status(snacks_git.git_status_picker_config)
      end,
      desc = "Show git status",
    },
    {
      "<leader>gh",
      function()
        Snacks.picker.git_log_file(snacks_git.git_commits_picker_config)
      end,
      desc = "Show git history of current file",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log(snacks_git.git_commits_picker_config)
      end,
      desc = "Show git log",
    },
    {
      "``",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume last picker",
    },
  },
}
