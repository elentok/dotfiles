local M = {}
local term = require("elentok.lib.terminal")
local luv = vim.loop

-- Root with a "tilde" for the user's home directory
function M.tilde_root()
  local root = M.root()
  if root == nil then
    return nil
  end

  return root:gsub(vim.env.HOME .. "/", "~/")
end

---@return string|nil
function M.root()
  local gitdir = vim.fn.finddir(".git", ";.")
  if gitdir == nil then
    return nil
  end

  return vim.fn.fnamemodify(vim.fn.fnamemodify(gitdir, ":h"), ":p")
end

local function is_buffer_in_cwd()
  local current_file = vim.fn.expand("%:p")
  local cwd = vim.fn.getcwd()

  -- Check if the current file path starts with the cwd
  return string.sub(current_file, 1, #cwd) == cwd
end

-- When inside a fugitive buffer its path is returned,
-- otherwise returns nil
---@return string|nil
local function extract_fugitive_path(path)
  if string.match(path, "^fugitive://") then
    path = string.gsub(path, "^fugitive://", ""):gsub("/*$", "")

    if vim.fn.fnamemodify(path, ":t") == ".git" then
      path = vim.fn.fnamemodify(path, ":h")
    end

    return path
  end
end

---@return string|nil
function M.find_git_root(filepath)
  local path = luv.fs_realpath(filepath)

  while path ~= "/" do
    if luv.fs_stat(path .. "/.git") then
      return path
    end
    path = luv.fs_realpath(path .. "/..")
  end
  return nil
end

---@return string|nil
function M.find_buffer_git_root()
  local path = vim.fn.expand("%")

  local fugitive_path = extract_fugitive_path(path)
  if fugitive_path ~= nil then
    return fugitive_path
  end

  return M.find_git_root(path)
end

-- When in a fugitive buffer, returns the fugitive directory,
-- When the current buffer is outside the current workdir it returns
-- the git root for that buffer,
-- Otherwise, returns nil.
---@return string|nil
local function identify_workdir()
  if is_buffer_in_cwd() then
    return nil
  end

  return M.find_buffer_git_root()
end

function M.run(args, opts)
  assert(#args > 0, "Expected at least 1 argument to git.run()")
  local cwd = identify_workdir()

  opts = vim.tbl_extend("force", {
    echo_cmd = true,
    wait = true,
    cwd = cwd,
  }, opts or {})
  local cmd = vim.list_extend({ "git" }, args)
  term.run(cmd, opts)
end

return M
