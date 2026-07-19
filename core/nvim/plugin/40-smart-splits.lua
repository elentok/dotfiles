---@module 'smart-splits'

-- Under Herdr, herdr-splits.nvim (40-herdr-splits.lua) takes over nav; avoid
-- double-binding ctrl/cmd-hjkl.
if vim.env.HERDR_ENV == "1" then return end

---@type SmartSplitsConfig
---@diagnostic disable-next-line: missing-fields
require("smart-splits").setup({
  at_edge = "stop",
})

vim.keymap.set(
  "n",
  "<c-h>",
  function() require("smart-splits").move_cursor_left() end,
  { desc = "Move left" }
)
vim.keymap.set(
  "n",
  "<c-j>",
  function() require("smart-splits").move_cursor_down() end,
  { desc = "Move down" }
)
vim.keymap.set(
  "n",
  "<c-k>",
  function() require("smart-splits").move_cursor_up() end,
  { desc = "Move up" }
)
vim.keymap.set(
  "n",
  "<c-l>",
  function() require("smart-splits").move_cursor_right() end,
  { desc = "Move right" }
)
vim.keymap.set(
  "n",
  "<D-h>",
  function() require("smart-splits").move_cursor_left() end,
  { desc = "Move left" }
)
vim.keymap.set(
  "n",
  "<D-j>",
  function() require("smart-splits").move_cursor_down() end,
  { desc = "Move down" }
)
vim.keymap.set(
  "n",
  "<D-k>",
  function() require("smart-splits").move_cursor_up() end,
  { desc = "Move up" }
)
vim.keymap.set(
  "n",
  "<D-l>",
  function() require("smart-splits").move_cursor_right() end,
  { desc = "Move right" }
)
