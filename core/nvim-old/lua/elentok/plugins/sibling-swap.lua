return {
  "Wansmer/sibling-swap.nvim",
  opts = {
    use_default_keymaps = false,
  },
  keys = {
    {
      "]s",
      function()
        require("sibling-swap").swap_with_right()
      end,
      mode = "n",
    },
    {
      "[s",
      function()
        require("sibling-swap").swap_with_left()
      end,
      mode = "n",
    },
  },
}
