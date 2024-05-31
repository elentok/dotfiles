-- Only use OSC52 when in an SSH  session
if vim.env.SSH_TTY == nil then
  return
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = function()
      return 0
    end,
    ["*"] = function()
      return 0
    end,
  },
}
