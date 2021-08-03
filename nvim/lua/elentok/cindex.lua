local utils = require "telescope.utils"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local conf = require("telescope.config").values

local function goto_symbol(opts)
  local results = utils.get_os_command_output({'cindex', 'list'})

  pickers.new(opts, {
    prompt_title = "Go To Symbol",
    sorter = conf.file_sorter(opts),
    finder = finders.new_table {
      results = results,
      entry_maker = function(line)
        local parts = vim.split(line, ",")
        local symbol = parts[1]
        local filename = parts[3]
        local lnum = parts[4]

        return {
          valid = true,

          value = symbol,
          ordinal = symbol,
          display = symbol,

          filename = filename,
          lnum = lnum,
          col = 0
        }
      end
    }
  }):find()
end


return {
  goto_symbol = goto_symbol,
}
