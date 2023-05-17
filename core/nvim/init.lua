require("elentok/loadtime")
local util = require("elentok/util")
-- util.safe_require("impatient")

if vim.env.DOTF == nil then
  vim.env.DOTF = vim.fn.expand("~/.dotfiles")
end

require("elentok/startup")

-- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
-- require("packer_compiled")
