require("mason").setup({})

vim.keymap.set("n", "<leader>om", function()
  vim.cmd.Mason()
end, { desc = "Open Mason" })
