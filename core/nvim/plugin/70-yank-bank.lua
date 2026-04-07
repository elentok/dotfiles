require("yankbank").setup({
  persist_type = "sqlite",
})

vim.keymap.set("n", "<leader>yy", "<cmd>YankBank<cr>")
