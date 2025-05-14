return {
  "mrjones2014/smart-splits.nvim",
  opts = {},
  lazy = false,
  keys = {
    {
      "<c-h>",
      function() require("smart-splits").move_cursor_left() end,
      desc = "Move left",
    },
    {
      "<c-j>",
      function() require("smart-splits").move_cursor_down() end,
      desc = "Move down",
    },
    {
      "<c-k>",
      function() require("smart-splits").move_cursor_up() end,
      desc = "Move up",
    },
    {
      "<c-l>",
      function() require("smart-splits").move_cursor_right() end,
      desc = "Move right",
    },
  },
}
