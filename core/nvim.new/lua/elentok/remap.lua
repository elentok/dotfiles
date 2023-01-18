local dot_repeat = require("elentok/dot-repeat")

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("n", "<c-s>", ":w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")
vim.keymap.set("n", "<space>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<space>/", ":nohls<cr>")
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

local function move_up()
  vim.cmd("m -2")
  dot_repeat.set(move_up)
end

local function move_down()
  vim.cmd("m +1")
  dot_repeat.set(move_down)
end

vim.keymap.set("n", "[e", move_up, { expr = true })
vim.keymap.set("n", "]e", move_down, { expr = true })
