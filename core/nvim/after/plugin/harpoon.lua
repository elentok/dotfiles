local ok, harpoon = pcall(require, "harpoon")

if not ok then
  return
end

local ui = require("harpoon.ui")
local mark = require("harpoon.mark")

harpoon.setup()

vim.keymap.set("n", "<space>a", function()
  mark.add_file()
end)
vim.keymap.set("n", "<space>e", function()
  ui.toggle_quick_menu()
end)
vim.keymap.set("n", "<space>1", function()
  ui.nav_file(1)
end)
vim.keymap.set("n", "<space>2", function()
  ui.nav_file(2)
end)
vim.keymap.set("n", "<space>3", function()
  ui.nav_file(3)
end)
vim.keymap.set("n", "<space>4", function()
  ui.nav_file(4)
end)
