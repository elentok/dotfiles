local color_picker = require("color-picker")
color_picker.setup()
vim.keymap.set("n", "<space>c", "<cmd>PickColor<cr>")
