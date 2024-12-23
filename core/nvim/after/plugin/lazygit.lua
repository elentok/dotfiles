local term = require("elentok.lib.terminal")

vim.keymap.set("n", "<leader>lg", function()
  term.run("lazygit", { wait = false })
end)

vim.keymap.set("n", "<leader>ls", function()
  term.run("lazygit status", { wait = false })
end)
