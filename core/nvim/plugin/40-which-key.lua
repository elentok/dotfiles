require("which-key").setup({
  preset = "helix",
})

vim.keymap.set(
  "n",
  "<leader>?",
  function() require("which-key").show({ global = false }) end,
  { desc = "Buffer Local Keymaps (which-key)" }
)
