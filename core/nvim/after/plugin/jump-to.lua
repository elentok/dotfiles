local builtin = require("telescope.builtin")
local util = require("elentok/util")

-- Configuration -------------------------------------------

local config_dirs = {
  vim.env.DOTF .. "/core/nvim",
}
util.add_dirs(config_dirs, { vim.env.DOTL .. "/nvim" })
util.add_dirs(config_dirs, { vim.env.DOTP .. "/nvim" })

local script_dirs = {
  vim.env.DOTF .. "/core/scripts",
  vim.env.DOTF .. "/scripts",
}
util.add_dirs(script_dirs, { vim.env.DOTL .. "/scripts" })

-- Functions -----------------------------------------------

local function jump_to_config()
  builtin.find_files({
    find_command = { "rg", "-t", "lua", "-t", "vim", "--files" },
    cwd = vim.env.HOME,
    search_dirs = config_dirs,
  })
end

local function jump_to_script()
  builtin.find_files({
    find_command = { "rg", "--files" },
    cwd = vim.env.HOME,
    search_dirs = script_dirs,
  })
end

local function jump_to_note()
  builtin.find_files({
    find_command = { "rg", "-t", "md", "--files" },
    cwd = vim.env.HOME .. "/notes",
  })
end

-- Keys ----------------------------------------------------

vim.keymap.set("n", "<space>js", jump_to_script, { desc = "Jump to script" })
vim.keymap.set("n", "<space>jc", jump_to_config, { desc = "Jump to config" })
vim.keymap.set("n", "<space>jn", jump_to_note, { desc = "Jump to note" })
vim.keymap.set(
  "n",
  "<space>jp",
  "<cmd>e ~/.dotfiles/core/nvim/lua/elentok/plugins/plugins.lua<cr>",
  { desc = "Jump to plugins.lua" }
)
vim.keymap.set(
  "n",
  "<space>jd",
  ':cd <C-R>=expand("%:p:h")<cr>',
  { desc = "CD to directory of current file" }
)
