require("elentok/loadtime")
local util = require("elentok/util")
-- util.safe_require("impatient")

if vim.env.DOTF == nil then
  vim.env.DOTF = vim.fn.expand("~/.dotfiles")
end

require("elentok/startup")
