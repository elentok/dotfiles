local map = require('elentok/map')

local function toggle_done()
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

map.normal('<Leader>td', map.lua('require("elentok/todo").toggle_done()'))

vim.cmd([[
  iabbr #todo ☐
  iabbr #done ✔
]])

return {toggle_done = toggle_done}
