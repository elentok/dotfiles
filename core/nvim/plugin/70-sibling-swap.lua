require("sibling-swap").setup({})

vim.keymap.set(
  "n",
  "]s",
  function() require("sibling-swap").swap_with_right() end,
  { desc = "Swap with right sibling" }
)
vim.keymap.set(
  "n",
  "[s",
  function() require("sibling-swap").swap_with_left() end,
  { desc = "Swap with left sibling" }
)
