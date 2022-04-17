local statusline_shorteners = {}
local statusline_shorteners_updated = false

local M = {}

function M.add_path_shortener(full, short)
  table.insert(statusline_shorteners, { full, short })
  statusline_shorteners_updated = true
end

function M.shorten(path)
  for _, item in ipairs(statusline_shorteners) do
    local full, short = unpack(item)
    path = path:gsub(full .. "/", short .. "/")
    path = path:gsub(full .. "$", short)
  end
  return path
end

function M.dir()
  if vim.b.vaffle ~= nil then
    local short_path = M.shorten(vim.b.vaffle["dir"])
    return short_path
  end

  -- Temporary solution
  if statusline_shorteners_updated then
    statusline_shorteners_updated = false
    if vim.b.short_path ~= nil then
      vim.b.short_path = nil
    end
  end

  if vim.b.short_path == nil then
    vim.b.short_path = M.shorten(vim.fn.expand("%:p:h"))
  end

  return vim.b.short_path
end

function M.filename()
  if vim.b.vaffle ~= nil then
    local short_path = M.shorten(vim.b.vaffle["dir"])
    return "DIR: " .. short_path
  end

  local name = vim.fn.expand("%:t")

  return string.format("%s (%s)", name, M.dir())
end

M.add_path_shortener(vim.env.HOME, "~")

return M
