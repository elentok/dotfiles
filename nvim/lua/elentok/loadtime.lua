local start = vim.fn.reltime()

function _G.ShowLoadTime()
  local elapsed_millisec = vim.fn.reltimefloat(vim.fn.reltime(start)) * 1000
  print(string.format("Loaded in %dms", elapsed_millisec))
end

vim.cmd("autocmd VimEnter * lua ShowLoadTime()")
