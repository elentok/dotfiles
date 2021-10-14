local util = require("elentok/util")
local map = require("elentok/map")

function _G.setup_quickfix()
  -- Always open quickfix window in full width
  if vim.fn.getwininfo(vim.fn.win_getid())[1].loclist ~= 1 then
    vim.cmd("wincmd J")
  end

  -- Set the error format so you can edit the quickfix
  vim.opt_local.errorformat = "%f\\|%l\\ col\\ %c\\|%m"

  -- Map <c-s> to reload the quickfix after changes
  map.buf_normal("<c-s>", ":cgetbuffer<cr>:setlocal nomodified<cr>")

  -- Map 'q' to close the quickfix window
  map.buf_normal("q", ":q<cr>")
end

util.augroup("QuickFix", [[
  autocmd FileType qf silent lua setup_quickfix()
]])
