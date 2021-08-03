local actions = require('telescope/actions')
local utils = require('telescope.utils')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values

require('telescope').setup {
  defaults = {
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = {
      "node_modules/.*",
      "scuba_goldens/.*",
    },
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist
      }
    }
  },
  extensions = {
    fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
    }
  }
}

require('telescope').load_extension('fzy_native')

local function make_entry(opts)
  return {
    valid = true,

    value = opts.text,
    ordinal = opts.text, -- used for the sorting order
    display = opts.text,

    filename = opts.filename,
    lnum = tonumber(opts.lnum),
    col = 0,
  }
end

local function command_picker(opts)
  local results = utils.get_os_command_output(opts.cmd)
  pickers.new(opts, {
    prompt_title = opts.title,
    sorter = conf.file_sorter({}),
    finder = finders.new_table {
      results = results,
      entry_maker = function(line)
        return make_entry(opts.parse_line(line))
      end
    }
  }):find()
end

return {
  command_picker = command_picker,
}
