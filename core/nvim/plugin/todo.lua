local map = require("elentok/map")

local unchecked = "%[ %]"
local checked = "%[x%]"

function _G.TodoToggleDone()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, unchecked)
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  end
  vim.fn.setline(".", line)
end

function _G.TodoNextState()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, unchecked)
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, "[inprogress]")
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", "[waiting]")
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", checked)
  end
  vim.fn.setline(".", line)
end

function _G.TodoPrevState()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, "[waiting]")
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", unchecked)
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", "[inprogress]")
  end
  vim.fn.setline(".", line)
end

map.normal("<Leader>td", map.lua("TodoToggleDone()"))
map.normal("<Leader>tp", map.lua("TodoPrevState()"))
map.normal("<Leader>tn", map.lua("TodoNextState()"))
