---@type Flash.Config
require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "ss", function() require("flash").jump() end, { desc = "Flash" })
