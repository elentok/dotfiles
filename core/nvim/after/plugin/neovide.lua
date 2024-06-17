if not vim.g.neovide then
  return
end

vim.o.guifont = "ComicShannsMono Nerd Font Mono:h16"
vim.o.linespace = 4

vim.keymap.set("n", "<D-h>", "<c-w>h")
vim.keymap.set("n", "<D-j>", "<c-w>j")
vim.keymap.set("n", "<D-k>", "<c-w>k")
vim.keymap.set("n", "<D-l>", "<c-w>l")
vim.keymap.set("n", "<D-d>", "<c-d>")
vim.keymap.set("n", "<D-u>", "<c-u>")
