local builtin = require("telescope.builtin")
local map = require("elentok/map")
local util = require("elentok/util")

local find_config_command = {
  "rg",
  "-t",
  "lua",
  "-t",
  "vim",
  "--files",
  vim.env.DOTF .. "/core/nvim"
}

util.add_dirs(find_config_command, {vim.env.DOTL .. "/nvim"})

function _G.goto_config()
  builtin.find_files({find_command = find_config_command})
end

local find_script_command = {
  "rg",
  "--files",
  vim.env.DOTF .. "/core/scripts",
  vim.env.DOTF .. "/scripts"
}

util.add_dirs(find_script_command, {vim.env.DOTL .. "/scripts"})

function _G.goto_script()
  builtin.find_files({find_command = find_script_command})
end

map.normal("<Leader>gb", map.lua("goto_script()"))
map.normal("<Leader>gc", map.lua("goto_config()"))
