local config = require("elentok/config")

local M = {}

function M.shorten(path)
  for full, short in pairs(config.path_shorteners) do
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

return M
