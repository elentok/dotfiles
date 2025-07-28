vim.keymap.set("v", "<leader>ys", function()
  local shell = require("stuff.util.shell")
  local lines = require("stuff.util.visual").get_lines()
  local result = shell("md2slack", { stdin = lines })

  if result.code ~= 0 then return end

  require("stuff.yank").yank(result.stdout)
end, { desc = "Yank to slack" })
