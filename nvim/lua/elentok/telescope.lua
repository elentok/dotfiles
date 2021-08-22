local actions = require 'telescope/actions'
local conf = require'telescope.config'.values
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local map = require 'elentok/map'
local pickers = require 'telescope.pickers'
local previewers = require 'telescope.previewers'
local utils = require 'telescope.utils'

require('telescope').setup {
  defaults = {
    -- file_sorter = require('telescope.sorters').get_fzy_sorter,
    file_ignore_patterns = {"node_modules/.*", "scuba_goldens/.*"},
    mappings = {i = {["<C-q>"] = actions.send_to_qflist + actions.open_qflist}}
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')

local function create_entry(opts)
  return {
    valid = true,

    value = opts.text,
    ordinal = opts.text, -- used for the sorting order
    display = opts.text,

    filename = opts.filename,
    lnum = tonumber(opts.lnum),
    col = 0
  }
end

local function command_picker(opts, picker_opts)
  if picker_opts == nil then picker_opts = {} end
  local results = utils.get_os_command_output(opts.cmd)
  pickers.new(picker_opts, {
    prompt_title = opts.title,
    sorter = opts.sorter or conf.file_sorter({}),
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or function(line)
        return create_entry(opts.parse_line(line))
      end
    }
  }):find()
end

local function buf_tags_picker(opts)
  opts = opts or {}
  command_picker({
    cmd = {
      'ctags', '-f', '-', '--sort=yes', '--excmd=number', vim.fn.bufname('%')
    },
    title = 'Buffer tags',
    entry_maker = make_entry.gen_from_ctags({path_display = 'hidden'}),
    previewer = previewers.ctags.new(opts),
    sorter = conf.generic_sorter(opts)
  })
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
map.normal('<Leader>fe',
           call_telescope('file_browser{ cwd = vim.fn.expand("%:p:h") }'))
map.normal('<Leader>ff',
           call_telescope('grep_string{ search = vim.fn.input("Grep for? ") }'))
map.normal('<Leader>fw',
           call_telescope('grep_string{ search = vim.fn.expand("<cword>") }'))
map.normal('gO', call_telescope(
               'lsp_document_symbols{ symbols = {"function", "method", "interface", "class"} }'))
map.normal('gR', call_telescope('lsp_references()'))
map.normal('``', map.lua('require("elentok/telescope").buf_tags_picker()'))

return {command_picker = command_picker, buf_tags_picker = buf_tags_picker}
