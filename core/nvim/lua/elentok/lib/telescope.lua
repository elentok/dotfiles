local ok, _ = pcall(require, "telescope")
if not ok then
  return
end

local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local utils = require("telescope.utils")

local M = {}

function M.create_entry(opts)
  return {
    valid = true,
    value = opts.text,
    ordinal = opts.text, -- used for the sorting order
    display = opts.display or opts.text,
    display_filename = opts.display_filename,
    filename = opts.filename,
    lnum = tonumber(opts.lnum),
    col = 0,
  }
end

function M.command_picker(opts, picker_opts)
  if picker_opts == nil then
    picker_opts = {}
  end
  local results = utils.get_os_command_output(opts.cmd)
  pickers
    .new(picker_opts, {
      prompt_title = opts.title,
      sorter = opts.sorter or conf.file_sorter({}),
      finder = finders.new_table({
        results = results,
        entry_maker = opts.entry_maker or function(line)
          return M.create_entry(opts.parse_line(line))
        end,
      }),
    })
    :find()
end

return M
