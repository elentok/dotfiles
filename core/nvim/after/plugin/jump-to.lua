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

---@param opts FindFilesOpts
local function find_files(opts)
  require("telescope.builtin").find_files(opts)
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

vim.keymap.set("n", "<leader>jc", function()
  find_files({
    find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
    cwd = vim.env.HOME,
    search_dirs = config_dirs,
  })
end, { desc = "Jump to config" })

vim.keymap.set("n", "<leader>jvp", function()
  find_files({
    cwd = vim.env.HOME .. "/.dotfiles/core/nvim/lua/elentok/plugins/",
  })
end, { desc = "Jump to plugin" })

vim.keymap.set("n", "<leader>jS", function()
  find_files({
    find_command = { "rg", "--files" },
    cwd = vim.env.HOME,
    search_dirs = script_dirs,
  })
end, { desc = "Jump to script" })

vim.keymap.set("n", "<leader>ja", "<c-^>", { desc = "Jump to alternate file" })

vim.keymap.set("n", "<leader>jp", function()
  require("fzf-lua").fzf_exec("dotf-projects list", {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        vim.fn.chdir(selected[1])
        vim.defer_fn(function()
          vim.notify("Changed directory to " .. selected[1])
        end, 10)
      end,
    },
  })
end, { desc = "Jump to project" })
