---@type LazySpec
return {
  "Wansmer/sibling-swap.nvim",
  requires = { "nvim-treesitter" },
  opts = {},
  keys = {
    {
      "]s",
      function() require("sibling-swap").swap_with_right() end,
      desc = "Swap with right sibling",
    },
    {
      "[s",
      function() require("sibling-swap").swap_with_left() end,
      desc = "Swap with left sibling",
    },
  },
}
