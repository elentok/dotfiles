local util = require("elentok/util")

-- Configuration -------------------------------------------

local config_dirs = {
  vim.env.DOTF .. "/core/nvim",
}

if vim.fn.isdirectory(vim.env.DOTP) == 1 then
  for _, plugin in ipairs(vim.fn.readdir(vim.env.DOTP)) do
    util.add_dirs(config_dirs, { vim.env.DOTP .. "/" .. plugin .. "/nvim" })
  end
end

local script_dirs = {
  vim.env.DOTF .. "/core/scripts",
  vim.env.DOTF .. "/scripts",
}

if vim.fn.isdirectory(vim.env.DOTP) == 1 then
  for _, plugin in ipairs(vim.fn.readdir(vim.env.DOTP)) do
    util.add_dirs(script_dirs, { vim.env.DOTP .. "/" .. plugin .. "/scripts" })
  end
end

-- Functions -----------------------------------------------

---@class FindFilesOpts
---@field cwd? string: root dir to search from (default: cwd, use utils.buffer_dir() to search relative to open buffer)
---@field find_command? function|table: cmd to use for the search. Can be a fn(opts) -> tbl (default: autodetect)
---@field no_ignore? boolean: show files ignored by .gitignore, .ignore, etc. (default: false)
---@field no_ignore_parent? boolean: show files ignored by .gitignore, .ignore, etc. in parent dirs. (default: false)
---@field search_dirs? table: directory/directories/files to search

---@param title string
---@param mapping string
---@param find_files_opts FindFilesOpts
local function create_jumper(title, mapping, find_files_opts)
  vim.keymap.set(
    "n",
    mapping,
    function()
      require("telescope.builtin").find_files(
        vim.tbl_extend("force", { prompt_title = "Jump to " .. title }, find_files_opts)
      )
    end,
    -- "<cmd>e ~/.dotfiles/core/nvim/lua/elentok/plugins/plugins.lua<cr>",
    { desc = "Jump to " .. title }
  )
end

local notes_re = vim.regex("^" .. vim.env.HOME .. "/notes")

local function jump_to_note()
  -- if not inside nodes, set cwd to notes
  local search_dirs = {}
  if notes_re and not notes_re:match_str(vim.fn.getcwd()) then
    search_dirs = { vim.env.HOME .. "/notes" }
  end

  local builtin = require("telescope.builtin")
  builtin.grep_string({
    search = "^# ",
    use_regex = true,
    search_dirs = search_dirs,
  })
end

-- Keys ----------------------------------------------------

create_jumper("config", "<leader>jc", {
  find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
  cwd = vim.env.HOME,
  search_dirs = config_dirs,
})

create_jumper("plugin", "<leader>jp", {
  cwd = vim.env.HOME .. "/.dotfiles/core/nvim/lua/elentok/plugins/",
})

create_jumper("script", "<leader>jS", {
  find_command = { "rg", "--files" },
  cwd = vim.env.HOME,
  search_dirs = script_dirs,
})

vim.keymap.set("n", "<leader>ja", "<c-^>", { desc = "Jump to alternate file" })
