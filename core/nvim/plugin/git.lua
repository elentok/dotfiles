local util = require("elentok/util")

vim.cmd([[
  command! -nargs=+ GG lua require('elentok/util').ishell('git <args>')
  command! Gps GG push
  command! Gpl GG pull --rebase
  command! Gsync GG sync
  command! -nargs=* Gap lua require('elentok/util').ishell('git add -p <args>', { large = true })
]])

local ok, git_conflict = pcall(require, "git-conflict")
if ok then
  git_conflict.setup()
end
