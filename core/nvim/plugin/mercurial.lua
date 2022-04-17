local create_cmd = vim.api.nvim_create_user_command
local builtin = require("telescope.builtin")

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

create_cmd("HgResolve", ":FloatermNew hg resolve --mark %", {})

vim.keymap.set("n", "<Leader>hm", hg_goto_modified)
vim.keymap.set("n", "<Leader>hu", hg_goto_unresolved)
