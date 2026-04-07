require("gitsigns").setup({
  preview_config = {
    border = "rounded",
  },
})

vim.keymap.set(
  "n",
  "<leader>gb",
  function() require("gitsigns").blame_line({ full = true }) end,
  { desc = "Git blame" }
)
vim.keymap.set(
  "n",
  "<leader>gh",
  function() require("gitsigns").preview_hunk() end,
  { desc = "Git preview hunk" }
)
vim.keymap.set(
  "n",
  "<leader>gt",
  function() require("gitsigns").toggle_word_diff() end,
  { desc = "Git toggle word diff" }
)
vim.keymap.set(
  "n",
  "[h",
  function() require("gitsigns").nav_hunk("prev") end,
  { desc = "Git hunk backward" }
)
vim.keymap.set(
  "n",
  "]h",
  function() require("gitsigns").nav_hunk("next") end,
  { desc = "Git hunk forward" }
)
