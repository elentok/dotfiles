---@module "lazy"
---@type LazySpec
return {
  "aserowy/tmux.nvim",
  opts = {
    copy_sync = {
      enable = false,
    },
    navigation = {
      cycle_navigation = false,
    },
    resize = {
      enable_default_keybindings = false,
    },
  },
  cond = vim.env.TMUX ~= nil,
  keys = {
    {
      "<c-h>",
      function() require("tmux").move_left() end,
    },
    {
      "<c-j>",
      function() require("tmux").move_bottom() end,
    },
    {
      "<c-k>",
      function() require("tmux").move_top() end,
    },
    {
      "<c-l>",
      function() require("tmux").move_right() end,
    },
  },
}
