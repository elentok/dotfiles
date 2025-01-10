local term = require("elentok.lib.terminal")
require("toggleterm.terminal")

--- @type Terminal | nil
local lazygit = nil

vim.keymap.set("n", "<leader>lg", function()
  if lazygit == nil then
    lazygit = term.run("lazygit", { wait = false })
  else
    lazygit:open()
  end

  vim.defer_fn(function()
    vim.cmd("startinsert!")
  end, 0)
end)
