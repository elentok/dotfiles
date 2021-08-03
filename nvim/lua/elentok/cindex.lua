local telescope = require('elentok/telescope')
local util = require 'lspconfig/util'

local root_finder = util.root_pattern('.git', '.hg')

local function set_root_finder(func)
  root_finder = func
end

local function index()
  root_dir = root_finder(vim.fn.expand('%:p')) or vim.loop.os_homedir()
  print('TODO: index' .. root_dir)
end


local function goto_symbol()
  telescope.command_picker({
    cmd = {'cindex', 'list'},
    parse_line = function(line)
      local parts = vim.split(line, ",")
      return {
        text = parts[1],
        filename = parts[3],
        lnum = parts[4]
      }
    end,
  })
end

return {
  index = index,
  goto_symbol = goto_symbol,
  set_root_finder = set_root_finder,
}
