local has_gps, gps = pcall(require, "nvim-gps")
local util = require("elentok/util")

if not has_gps then
  return
end

local M = {}

function M.get_logger_prefix()
  local data = gps.get_data()
  if data == "" then
    return nil
  end

  local container = nil
  local name = nil

  for _, part in pairs(data) do
    if part.type == "function-name" then
      name = part.text
    elseif part.type == "method-name" then
      name = part.text
    elseif part.type == "class-name" then
      container = part.text
    end
  end

  if container == nil then
    container = vim.fn.expand("%:t")
  end

  if name == nil then
    return container
  end

  return container .. " > " .. name .. "()"
end

function M.get_logger_line()
  local prefix = M.get_logger_prefix()
  if prefix == nil then
    return ""
  end

  local filetype = util.buf_get_filetype()
  if filetype == "typescript" or filetype == "javascript" then
    return "console.log('[" .. prefix .. "]');"
  elseif filetype == "lua" then
    return "put('[" .. prefix .. "]');"
  else
    return ""
  end
end

return M
