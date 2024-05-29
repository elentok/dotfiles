local navic = require("nvim-navic")
local util = require("elentok/util")
local ui = require("elentok.lib.ui")

-- local prefix = "[" .. vim.env.USER .. "]"
local prefix = "[bazinga]"

local config = {
  types = { "Function", "Method", "Class", "Constant" },
  max_part_width = 20,
  max_parts = 3,
  max_context_width = 50,
}

local function ellipsis_one(name)
  if name:len() > config.max_part_width then
    return name:sub(0, config.max_part_width + 1) .. "..."
  end

  return name
end

local function cleanup(name)
  name = name:gsub("'", "")

  if name:match("^describe[%(.]") then
    name = name:gsub("^describe[^%(]*%(", "")
  elseif name:match("^it[%(.]") then
    name = name:gsub("^it[^%(]*%(", "")
  elseif name:match("^test[%(.]") then
    name = name:gsub("^test[^%(]*%(", "")
  end

  name = name:gsub("%) callback", "")

  return name
end

local function show_part(part)
  if not vim.tbl_contains(config.types, part.type) then
    return false
  end

  return part.name ~= "<function>"
end

local function get_logger_context()
  local data = navic.get_data()
  if data == "" or data == nil then
    return nil
  end

  local parts = {}
  for _, part in pairs(data) do
    if show_part(part) then
      table.insert(parts, ellipsis_one(cleanup(part.name)))
    end
  end

  if #parts == 0 then
    return nil
  end

  if #parts > config.max_parts then
    parts[2] = "..."
    while #parts > config.max_parts do
      table.remove(parts, 3)
    end
  end

  return table.concat(parts, " > ")
end

local function get_logger_line()
  -- local context = get_logger_context()
  --
  -- if context == nil then
  local context = "L" .. vim.fn.line(".")
  -- end

  local filename = vim.fn.expand("%:t")

  local log = prefix .. " [" .. filename .. "] " .. context

  local filetype = util.buf_get_filetype()
  if filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascript" then
    return "console.log('" .. log .. "')"
  elseif filetype == "lua" then
    return "put('" .. log .. "')"
  elseif filetype == "sh" then
    return 'echo "' .. log .. '"'
  else
    return ""
  end
end

vim.keymap.set("i", "<c-l>", function()
  vim.api.nvim_put({ get_logger_line() }, "c", true, true)
  ui.feedkeys("<Left>")
end)
