vim.keymap.set("n", "<leader>om", function()
  require("config.mason").open()
end, { desc = "Open Mason" })
