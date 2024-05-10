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

local function jump_to_config()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
    cwd = vim.env.HOME,
    search_dirs = config_dirs,
  })
end

local function jump_to_script()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    find_command = { "rg", "--files" },
    cwd = vim.env.HOME,
    search_dirs = script_dirs,
  })
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

  -- builtin.find_files({
  --   find_command = { "rg", "-t", "md", "--files" },
  --   cwd = cwd,
  -- })
end

-- Keys ----------------------------------------------------

vim.keymap.set("n", "<leader>ja", "<c-^>", { desc = "Jump to alternate file" })
-- vim.keymap.set("n", "<leader>js", jump_to_script, { desc = "Jump to script" })
vim.keymap.set("n", "<leader>jc", jump_to_config, { desc = "Jump to config" })
-- vim.keymap.set("n", "<leader>jn", jump_to_note, { desc = "Jump to note" })
vim.keymap.set(
  "n",
  "<leader>jp",
  "<cmd>e ~/.dotfiles/core/nvim/lua/elentok/plugins/plugins.lua<cr>",
  { desc = "Jump to plugins.lua" }
)
