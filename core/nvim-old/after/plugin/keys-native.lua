if vim.g.vscode then
  return
end

vim.keymap.set("n", "<leader>wh", "<c-w>h", { desc = "Go to window to the left" })
vim.keymap.set("n", "<leader>wj", "<c-w>j", { desc = "Go to window below" })
vim.keymap.set("n", "<leader>wk", "<c-w>k", { desc = "Go to window above" })
vim.keymap.set("n", "<leader>wl", "<c-w>l", { desc = "Go to window to the right" })

vim.keymap.set("n", "<leader>wo", "<c-w>o", { desc = "Only window" })
vim.keymap.set("n", "<leader>ws", "<c-w>s", { desc = "Split window" })
vim.keymap.set("n", "<leader>wv", "<c-w>v", { desc = "Split window vertically" })

vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = ":wq" })
vim.keymap.set("n", "<leader>wa", "<cmd>wa<cr>", { desc = ":wa" })
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = ":qa" })
vim.keymap.set("n", "<leader>cq", "<cmd>cq<cr>", { desc = ":cq" })
vim.keymap.set("n", "<leader>qq", "<cmd>q<cr>", { desc = ":q" })

-- Switch to alternate file
vim.keymap.set("n", "<leader><leader>", "<c-^>")
