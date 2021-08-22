local util = require('elentok/util')

function _G.WinSaveCursor()
  vim.w.last_cursor = vim.api.nvim_win_get_cursor(0)
end

function _G.WinRestoreCursor()
  if (vim.w.last_cursor) then util.restore_cursor(0, vim.w.last_cursor) end
end

util.augroup('PreserveCursor', [[
  autocmd BufReadPre * lua WinSaveCursor()
  autocmd BufReadPost * lua WinRestoreCursor()
]])
