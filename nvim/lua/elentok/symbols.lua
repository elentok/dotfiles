local telescope = require('elentok/telescope')
local map = require('elentok/map')
local util = require('lspconfig/util')

local root_finder = util.root_pattern('.git', '.hg')

local M = {}

function M.set_root_finder(func)
  root_finder = func
end

function M.index()
  local root_dir = root_finder(vim.fn.expand('%:p')) or vim.loop.os_homedir()
  print('TODO: index' .. root_dir)
end

function M.goto_symbol()
  telescope.command_picker({
    cmd = {'symbols', 'list'},
    parse_line = function(line)
      local parts = vim.split(line, ",")
      return {text = parts[1], filename = parts[3], lnum = parts[4]}
    end
  })
end

-- Keys
map.normal('<Leader>gs', map.lua("require('elentok/symbols').goto_symbol()"))

return M
