local builtin = require("telescope/builtin")

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
local function grep()
  vim.ui.input({prompt = ":grep? "}, function(query)
    if query ~= nil then
      vim.cmd("silent grep " .. query)
    end
  end)
end

-- Grep with telescope (can't pass ripgrep arguments but includes preview and
-- filtering).
local function telescope_grep()
  vim.ui.input({prompt = "Grep for? "}, function(query)
    if query ~= nil then
      builtin.grep_string {search = query, regex = true}
    end
  end)
end

vim.keymap.set("n", "<Leader>ff", telescope_grep)
vim.keymap.set("n", "<Leader>fq", grep)
