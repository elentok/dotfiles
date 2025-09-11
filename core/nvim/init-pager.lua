vim.keymap.set("n", "q", "<Cmd>q<cr>")
vim.keymap.set("n", "vv", "V")
vim.keymap.set("n", "vc", "<c-v>")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "ge", "G")
vim.keymap.set("n", "yl", "0vg_y")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.clipboard = { "unnamed", "unnamedplus" }
