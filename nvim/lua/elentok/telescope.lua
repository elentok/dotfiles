local map = require('elentok/map')
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

-- Keys

local function call_telescope(expr)
  return map.lua('require("telescope.builtin").' .. expr)
end

map.normal('<c-p>', call_telescope('find_files{}'))
map.normal('<Leader>b', call_telescope('buffers{}'))
map.normal('<Leader>gt', call_telescope('tags{}'))
map.normal('<Leader>gg', call_telescope('git_status{}'))
map.normal('<Leader>gh', call_telescope('help_tags{}'))
map.normal('<Leader>gm', call_telescope('oldfiles{ previewer = false}'))
map.normal('<Leader>fe', call_telescope('file_browser{ cwd = vim.fn.expand("%:p:h") }'))
map.normal('<Leader>ff', call_telescope('grep_string{ search = vim.fn.input("Grep for?") }'))
map.normal('<Leader>fw', call_telescope('grep_string{ search = vim.fn.expand("<cword>") }'))
map.normal('gO', call_telescope('lsp_document_symbols{ symbols = {"function", "method", "interface", "class"} }'))
map.normal('gR', call_telescope('lsp_references()'))

return {
  command_picker = command_picker,
}
