local map = require('elentok/map')

local function next_state()
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

local function prev_state()
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

map.normal('<Leader>tp', map.lua('require("elentok/todo").prev_state()'))
map.normal('<Leader>tn', map.lua('require("elentok/todo").next_state()'))

vim.cmd([[
  iabbr #todo ☐
  iabbr #done ✔
]])

return {next_state = next_state, prev_state = prev_state}
