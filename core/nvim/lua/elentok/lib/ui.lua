local M = {}

function M.confirm(question)
  return vim.fn.confirm(question, "&Yes\n&No") == 1
end

return M
