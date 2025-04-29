-- Disable hinting as it's causing the font to look too bold
-- (see https://neovide.dev/configuration.html)
vim.o.guifont = "Agave Nerd Font:h18:#h-none"

vim.g.neovide_cursor_animation_length = 0.05
vim.g.neovide_touch_drag_timeout = 0.15

vim.o.linespace = 6

local function map_cmd_to_ctrl()
  -- Removed "v" on purpose since Cmd+V pastes
  local keys = "abcdefghijklmnopqrstuwxyz[]\\^_0"
  for i = 1, #keys do
    local key = string.sub(keys, i, i)
    vim.keymap.set({ "t", "n", "i", "v", "x", "c" }, "<D-" .. key .. ">", "<c-" .. key .. ">", { remap = true })
  end
end

vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
vim.keymap.set("i", "<D-v>", "<C-R>+") -- Paste insert mode
vim.keymap.set("t", "<D-v>", "<C-\\><c-n>pi") -- Paste terminal mode

map_cmd_to_ctrl()
