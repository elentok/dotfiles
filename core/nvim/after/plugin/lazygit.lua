local term = require("elentok.lib.terminal")
require("toggleterm.terminal")

--- @type Terminal | nil
local lazygit = nil

local function openLazyGit()
  if lazygit == nil then
    lazygit = term.run({ "lazygit", "status" }, {
      wait = false,
      ---@param trm Terminal
      on_open = function(trm)
        vim.keymap.set({ "i", "t", "n" }, "<c-p>", "<cmd>close<cr>", { buffer = trm.bufnr })
      end,
    })
  else
    lazygit:open()
  end
end

vim.keymap.set("n", "<leader>lg", openLazyGit)
vim.keymap.set("n", "<c-p>", openLazyGit)
