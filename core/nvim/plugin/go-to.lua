local builtin = require("telescope.builtin")
local util = require("elentok/util")

local find_config_command = {
  "rg",
  "-t",
  "lua",
  "-t",
  "vim",
  "--files",
  vim.env.DOTF .. "/core/nvim",
}

util.add_dirs(find_config_command, { vim.env.DOTL .. "/nvim" })

local function goto_config()
  builtin.find_files({ find_command = find_config_command })
end

local find_script_command = {
  "rg",
  "--files",
  vim.env.DOTF .. "/core/scripts",
  vim.env.DOTF .. "/scripts",
}

util.add_dirs(find_script_command, { vim.env.DOTL .. "/scripts" })

local function goto_script()
  builtin.find_files({ find_command = find_script_command })
end

vim.keymap.set("n", "<Leader>gb", goto_script)
vim.keymap.set("n", "<Leader>gc", goto_config)
