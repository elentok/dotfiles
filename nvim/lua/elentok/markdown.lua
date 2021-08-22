local util = require('elentok/util')
local M = {}

M.foldexpr = function(lnum)
    local line = vim.fn.getline(lnum)

    local match = line:match("^#+")
    if match then
        return '>' .. string.len(match)
    else
        return '='
    end
end

vim.cmd([[
  function! ElentokMarkdownFoldExpr(lnum)
  	return luaeval(printf('require"elentok/markdown".foldexpr(%d)', a:lnum))
  endfunction
]])

util.augroup('Markdown', [[
  autocmd FileType markdown setlocal textwidth=80 spell spellcapcheck= foldlevel=1
  autocmd FileType markdown setlocal foldmethod=expr foldexpr=ElentokMarkdownFoldExpr(v:lnum)
]])

return M
