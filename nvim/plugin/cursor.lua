local util = require("elentok/util")

function _G.WinSaveCursor()
  vim.w.last_cursor = vim.fn.getpos(".")
end

function _G.WinRestoreCursor()
  if (vim.w.last_cursor) then
    vim.fn.setpos(".", vim.w.last_cursor)
  end
end

util.augroup("PreserveCursor", [[
  autocmd BufReadPre * lua WinSaveCursor()
  autocmd BufReadPost * lua WinRestoreCursor()
]])
