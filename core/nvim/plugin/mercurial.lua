local create_cmd = vim.api.nvim_create_user_command
local builtin = require("telescope.builtin")
local _, fterm = pcall(require, "FTerm")

local function hg_goto_modified()
  builtin.find_files({ find_command = { "hg", "status", "--no-status" } })
end

local function hg_goto_unresolved()
  builtin.find_files({
    find_command = {
      "hg",
      "resolve",
      "--no-status",
      "--list",
      "set:unresolved()",
    },
  })
end

local function hg_diff()
  fterm.scratch({ cmd = { "hg", "diff", vim.api.nvim_buf_get_name(0) } })
end

local function hg_resolve()
  fterm.scratch({ cmd = { "hg", "resolve", "--mark", vim.api.nvim_buf_get_name(0) } })
end

vim.keymap.set("n", "<Leader>hm", hg_goto_modified)
vim.keymap.set("n", "<Leader>hu", hg_goto_unresolved)
vim.keymap.set("n", "<Leader>hd", hg_diff)
vim.keymap.set("n", "<Leader>hr", hg_resolve)
