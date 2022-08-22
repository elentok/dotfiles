local ok, iswap = pcall(require, "iswap")

if not ok then
  return
end

iswap.setup()

vim.keymap.set("n", "<space>ss", "<cmd>ISwapWith<cr>")
vim.keymap.set("n", "<space>sn", "<cmd>ISwapNodeWith<cr>")
