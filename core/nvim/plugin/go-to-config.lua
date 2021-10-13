local builtin = require "telescope.builtin"
local map = require "elentok/map"

local find_command = {
  "rg", "-t", "lua", "-t", "vim", "--files", vim.env.DOTF .. "/core/nvim"
}

if vim.fn.isdirectory(vim.env.DOTL .. "/nvim") == 1 then
  table.insert(find_command, vim.env.DOTL .. "/nvim")
end

function _G.find_config()
  builtin.find_files({find_command = find_command})
end

map.normal("<Leader>gc", map.lua("find_config()"))
