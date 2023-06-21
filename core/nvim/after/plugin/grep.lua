local conf = require("telescope/config").values
local finders = require("telescope/finders")
local make_entry = require("telescope/make_entry")
local pickers = require("telescope/pickers")

-- Use "ripgrep" for the :grep command when available.
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Abbreviate ":grep" to ":silent grip" to avoid seeing.
vim.cmd([[
  cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'
]])

-- Grep with ":grep" (allows passing custom args)
local function grep()
  vim.ui.input({ prompt = ":grep? " }, function(query)
    if query ~= nil then
      vim.cmd("silent grep " .. query)
    end
  end)
end

local function split_args(args)
  if args == nil or args == "" then
    return {}
  end

  if args:sub(1, 1) == "\\" then
    return { args:sub(2) }
  end

  return vim.split(args, " ", { plain = true, trimempty = true })
end

-- Grep with telescope.
local function telescope_grep(query, opts)
  opts = opts or {}
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  local args = {}
  if opts.cwd then
    table.insert(args, opts.cwd)
    opts.cwd = nil
  end

  put(opts)
  put(args)

  local command = vim.tbl_flatten({ conf.vimgrep_arguments, query, args })

  put(command)

  if query == nil then
    return
  end

  if vim.tbl_islist(query) then
    query = vim.fn.join(query, " ")
  end

  pickers
    .new(opts, {
      prompt_title = "Grep for [" .. query .. "]",
      finder = finders.new_oneshot_job(command, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

-- Grep with telescope (prompt for query).
local function telescope_grep_with_prompt(opts)
  opts = opts or {}
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  vim.ui.input({ prompt = "Grep for? " }, function(query)
    telescope_grep(split_args(query), opts)
  end)
end

vim.keymap.set("n", "<Leader>ff", function()
  telescope_grep_with_prompt()
end)
vim.keymap.set("n", "<Leader>fw", function()
  telescope_grep(vim.fn.expand("<cword>"))
end)
vim.keymap.set("n", "<Leader>fq", grep)

vim.keymap.set("n", "<Leader>fd", function()
  telescope_grep_with_prompt({ cwd = vim.fn.expand("%:h") })
end)
