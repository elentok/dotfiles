local ok, hop = pcall(require, "hop")

if not ok then
  return
end

hop.setup({})

vim.keymap.set("n", "<space>w", "<cmd>HopWord<cr>")
vim.keymap.set("n", "<space>l", "<cmd>HopLine<cr>")
vim.keymap.set("v", "<space>w", "<cmd>HopWord<cr>")
vim.keymap.set("v", "<space>l", "<cmd>HopLine<cr>")
