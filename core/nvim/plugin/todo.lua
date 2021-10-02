local map = require("elentok/map")

function _G.TodoToggleDone()
  local line = vim.fn.getline(".")
  if line:match("✔") then
    line = line:gsub("✔", "☐")
  elseif line:match("☐") then
    line = line:gsub("☐", "✔")
  end
  vim.fn.setline(".", line)
end

function _G.TodoNextState()
  local line = vim.fn.getline(".")
  if line:match("✔") then
    line = line:gsub("✔", "☐")
  elseif line:match("☐") then
    line = line:gsub("☐", "(inprogress)")
  elseif line:match("%(inprogress%)") then
    line = line:gsub("%(inprogress%)", "(waiting)")
  elseif line:match("%(waiting%)") then
    line = line:gsub("%(waiting%)", "✔")
  end
  vim.fn.setline(".", line)
end

function _G.TodoPrevState()
  local line = vim.fn.getline(".")
  if line:match("✔") then
    line = line:gsub("✔", "(waiting)")
  elseif line:match("☐") then
    line = line:gsub("☐", "✔")
  elseif line:match("%(inprogress%)") then
    line = line:gsub("%(inprogress%)", "☐")
  elseif line:match("%(waiting%)") then
    line = line:gsub("%(waiting%)", "(inprogress)")
  end
  vim.fn.setline(".", line)
end

map.normal("<Leader>td", map.lua("TodoToggleDone()"))
map.normal("<Leader>tp", map.lua("TodoPrevState()"))
map.normal("<Leader>tn", map.lua("TodoNextState()"))

vim.cmd([[
  iabbr #todo ☐
  iabbr #done ✔
]])
