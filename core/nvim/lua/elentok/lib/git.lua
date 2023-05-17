local M = {}

function M.root()
  local gitdir = vim.fn.finddir(".git")
  if gitdir == nil then
    return nil
  end

  return vim.fn.fnamemodify(gitdir, ":h")
end

return M
