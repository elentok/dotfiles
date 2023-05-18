local M = {}

-- Root with a "tilde" for the user's home directory
function M.tilde_root()
  local root = M.root()
  if root == nil then
    return nil
  end

  return root:gsub(vim.env.HOME .. "/", "~/")
end

function M.root()
  local gitdir = vim.fn.finddir(".git", ";.")
  if gitdir == nil then
    return nil
  end

  return vim.fn.fnamemodify(vim.fn.fnamemodify(gitdir, ":h"), ":p")
end

return M
