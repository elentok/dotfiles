local builtin = require("telescope.builtin")
local map = require("elentok/map")

function _G.hg_goto_modified()
  builtin.find_files({find_command = {"hg", "status", "--no-status"}})
end

function _G.hg_goto_unresolved()
  builtin.find_files({
    find_command = {
      "hg",
      "resolve",
      "--no-status",
      "--list",
      "set:unresolved()"
    }
  })
end

vim.cmd([[
  command! HgModified lua hg_goto_modified()
  command! HgUnresolved lua hg_goto_unresolved()
  command! HgResolve QuickShell hg resolve --mark %
]])

map.normal("<Leader>hm", ":HgModified<cr>")
map.normal("<Leader>hu", ":HgUnresolved<cr>")
