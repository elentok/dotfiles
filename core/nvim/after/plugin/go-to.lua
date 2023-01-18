local ok, builtin = pcall(require, "telescope.builtin")

if not ok then
  return
end

local util = require("elentok/util")

-- Configuration -------------------------------------------

local config_dirs = {
  vim.env.DOTF .. "/core/nvim",
}
util.add_dirs(config_dirs, { vim.env.DOTL .. "/nvim" })

local script_dirs = {
  vim.env.DOTF .. "/core/scripts",
  vim.env.DOTF .. "/scripts",
}
util.add_dirs(script_dirs, { vim.env.DOTL .. "/scripts" })

-- Functions -----------------------------------------------

local function goto_config()
  builtin.find_files({
    find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
    cwd = vim.env.HOME,
    search_dirs = config_dirs,
  })
end

local function goto_script()
  builtin.find_files({
    find_command = { "rg", "--files" },
    cwd = vim.env.HOME,
    search_dirs = script_dirs,
  })
end

local function goto_note()
  builtin.find_files({
    find_command = { "rg", "-t", "md", "--files" },
    cwd = vim.env.HOME .. "/notes",
  })
end

-- Keys ----------------------------------------------------

vim.keymap.set("n", "<Leader>gb", goto_script)
vim.keymap.set("n", "<Leader>gc", goto_config)
vim.keymap.set("n", "<Leader>gn", goto_note)
