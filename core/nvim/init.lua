require("elentok/loadtime")
local util = require("elentok/util")
util.safe_require("impatient")

vim.g.do_filetype_lua = 1

local local_config = vim.fn.expand("~/.dotlocal/nvim")
if vim.fn.isdirectory(local_config) then
  vim.opt.runtimepath:append(local_config)
end

if vim.env.DOTF == nil then
  vim.env.DOTF = vim.fn.expand("~/.dotfiles")
end

require("elentok")

-- disable for now (https://github.com/wbthomason/packer.nvim/issues/201)
-- require("packer_compiled")
