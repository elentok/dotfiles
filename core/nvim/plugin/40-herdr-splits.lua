---@module 'herdr-splits'

-- Only active under Herdr; smart-splits.nvim (40-smart-splits.lua) handles
-- kitty/tmux nav everywhere else.
if vim.env.HERDR_ENV ~= "1" then return end

require("herdr-splits").setup({
  at_edge = "stop",
})

vim.keymap.set(
  "n",
  "<c-h>",
  function() require("herdr-splits").move_cursor_left() end,
  { desc = "Move left" }
)
vim.keymap.set(
  "n",
  "<c-j>",
  function() require("herdr-splits").move_cursor_down() end,
  { desc = "Move down" }
)
vim.keymap.set(
  "n",
  "<c-k>",
  function() require("herdr-splits").move_cursor_up() end,
  { desc = "Move up" }
)
vim.keymap.set(
  "n",
  "<c-l>",
  function() require("herdr-splits").move_cursor_right() end,
  { desc = "Move right" }
)
vim.keymap.set(
  "n",
  "<D-h>",
  function() require("herdr-splits").move_cursor_left() end,
  { desc = "Move left" }
)
vim.keymap.set(
  "n",
  "<D-j>",
  function() require("herdr-splits").move_cursor_down() end,
  { desc = "Move down" }
)
vim.keymap.set(
  "n",
  "<D-k>",
  function() require("herdr-splits").move_cursor_up() end,
  { desc = "Move up" }
)
vim.keymap.set(
  "n",
  "<D-l>",
  function() require("herdr-splits").move_cursor_right() end,
  { desc = "Move right" }
)
