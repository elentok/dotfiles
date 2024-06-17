if not vim.g.neovide then
  return
end

vim.o.guifont = "ComicShannsMono Nerd Font Mono:h16"
vim.o.linespace = 4

-- vim.g.neovide_transparency = 0.95
-- vim.g.transparency = 0.95
-- vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_animation_length = 0.01
vim.g.neovide_touch_drag_timeout = 0.15
vim.g.neovide_input_use_logo = true
vim.g.neovide_window_blurred = true
-- vim.g.neovide_show_border = true
vim.g.neovide_remember_window_size = true
vim.g.neovide_theme = "auto"
vim.g.neovide_input_use_logo = 1

vim.keymap.set({ "n", "t", "i", "v" }, "<D-c>", "<c-c>")
vim.keymap.set("n", "<D-h>", "<c-w>h")
vim.keymap.set("n", "<D-j>", "<c-w>j")
vim.keymap.set("n", "<D-l>", "<c-w>l")
vim.keymap.set("n", "<D-d>", "<c-d>")
vim.keymap.set("n", "<D-u>", "<c-u>")

-- terminal
vim.keymap.set("t", "<D-h>", "<c-\\><c-n><c-w>h")
vim.keymap.set("t", "<D-j>", "<c-\\><c-n><c-w>j")
vim.keymap.set("t", "<D-k>", "<c-\\><c-n><c-w>k")
vim.keymap.set("t", "<D-l>", "<c-\\><c-n><c-w>l")

vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
