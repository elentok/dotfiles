local util = require("elentok/util")
local M = {}

M.setup_buffer = function()
  -- Spell checking
  vim.wo.spell = true
  vim.bo.spellcapcheck = ""

  -- Setup folding by headings.
  vim.wo.foldlevel = 1
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "ElentokMarkdownFoldExpr(v:lnum)"

  -- Automatic word wrapping.
  vim.bo.textwidth = 80
  -- n = recognize numbered lists
  -- b = auto wrap only if not already longer than textwidth
  vim.bo.formatoptions = vim.bo.formatoptions .. "nb"
end

M.foldexpr = function(lnum)
  local line = vim.fn.getline(lnum)

  local match = line:match("^#+")
  if match then
    return ">" .. string.len(match)
  else
    return "="
  end
end

vim.cmd([[
  function! ElentokMarkdownFoldExpr(lnum)
  	return luaeval(printf('require"elentok/markdown".foldexpr(%d)', a:lnum))
  endfunction
]])

util.augroup("Markdown", [[
  autocmd FileType markdown lua require("elentok/markdown").setup_buffer()
]])

return M
