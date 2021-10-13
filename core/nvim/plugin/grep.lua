local builtin = require("telescope/builtin")
local map = require("elentok/map")

-- Use "ripgrep" for the :grep command when available.
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- Abbreviate ":grep" to ":silent grip" to avoid seeing.
vim.cmd([[
  cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep'  : 'grep'
]])

-- Grep with ":grep" (allows passing custom args)
function _G.grep()
  local query = vim.fn.input(":grep? ")
  vim.cmd("silent grep " .. query)
end

-- Grep with telescope (can't pass ripgrep arguments but includes preview and
-- filtering).
function _G.telescope_grep()
  local query = vim.fn.input("Grep for? ")
  builtin.grep_string {search = query, regex = true}
end

map.normal("<Leader>ff", map.lua("telescope_grep()"))
map.normal("<Leader>fq", map.lua("grep()"))
