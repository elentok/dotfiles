local map = require('elentok/map')

local M = {}

function M.toggle_done()
  local line = vim.fn.getline('.')
  if line:match("✔") then
    line = line:gsub("✔", "☐")
  elseif line:match("☐") then
    line = line:gsub("☐", "✔")
  end
  vim.fn.setline('.', line)
end

function M.next_state()
  local line = vim.fn.getline('.')
  if line:match("✔") then
    line = line:gsub("✔", "☐")
  elseif line:match("☐") then
    line = line:gsub("☐", "(inprogress)")
  elseif line:match("%(inprogress%)") then
    line = line:gsub("%(inprogress%)", "(waiting)")
  elseif line:match("%(waiting%)") then
    line = line:gsub("%(waiting%)", "✔")
  end
  vim.fn.setline('.', line)
end

function M.prev_state()
  local line = vim.fn.getline('.')
  if line:match("✔") then
    line = line:gsub("✔", "(waiting)")
  elseif line:match("☐") then
    line = line:gsub("☐", "✔")
  elseif line:match("%(inprogress%)") then
    line = line:gsub("%(inprogress%)", "☐")
  elseif line:match("%(waiting%)") then
    line = line:gsub("%(waiting%)", "(inprogress)")
  end
  vim.fn.setline('.', line)
end

map.normal('<Leader>td', map.lua('require("elentok/todo").toggle_done()'))
map.normal('<Leader>tp', map.lua('require("elentok/todo").prev_state()'))
map.normal('<Leader>tn', map.lua('require("elentok/todo").next_state()'))

vim.cmd([[
  iabbr #todo ☐
  iabbr #done ✔
]])

return M
