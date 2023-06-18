local navic = require("nvim-navic")
local util = require("elentok/util")

local prefix = "[" .. vim.env.USER .. "]"
local max_context_width = 50

local function get_logger_context()
  local data = navic.get_data()
  if data == "" then
    return nil
  end

  local container = nil
  local name = nil

  for _, part in pairs(data) do
    if part.type == "Function" then
      name = part.name
    elseif part.type == "Method" then
      name = part.name
    elseif part.type == "Class" then
      container = part.name
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

local function get_logger_line()
  local context = get_logger_context()
  if context == nil then
    return ""
  end

  context = context:gsub("'", "\\'")
  if context:len() > max_context_width then
    context = context:sub(0, max_context_width + 1) .. "..."
  end
  context = "[" .. context .. "]"

  local filetype = util.buf_get_filetype()
  if filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascript" then
    return "console.log('" .. prefix .. " " .. context .. "');"
  elseif filetype == "lua" then
    return "put('" .. prefix .. " " .. context .. "');"
  else
    return ""
  end
end

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

vim.keymap.set("i", "<c-l>", function()
  vim.api.nvim_put({ get_logger_line() }, "c", true, true)
  feedkeys("<Left><Left>")
end)
