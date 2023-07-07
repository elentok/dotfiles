local ok, color_picker = pcall(require, "color-picker")

if not ok then
  return
end

color_picker.setup()
vim.keymap.set("n", "<space>c", "<cmd>PickColor<cr>")
