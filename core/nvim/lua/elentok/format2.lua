local util = require("elentok/util")
local message = require("elentok/message")

local M = {}

M.formatters = {}
M.formatter_by_filetype = {}

function M.add_formatter(name, formatter)
  M.formatters[name] = formatter

  for _, filetype in ipairs(formatter.filetypes or {}) do
    M.formatter_by_filetype[filetype] = formatter
  end
end

M.add_formatter("black", {
  command = "black --quiet --stdin-filename % -",
  filetypes = {"python"}
})

M.add_formatter("clang",
                {command = "clang-format --style=Google --assume-filename %"})

M.add_formatter("luaformat", {
  command = "lua-format --config=$HOME/.lua-format",
  filetypes = {"lua"}
})

M.add_formatter("prettier", {
  command = "prettierd %",
  filetypes = {
    "css", "html", "javascript", "json", "markdown", "typescript",
    "typescriptreact"
  }
})

M.add_formatter("lsp", {
  func = function()
    vim.lsp.buf.formatting_seq_sync()
  end,
  filetypes = {"scss", "sh", "java", "yaml"}
})

local function same_lines(list1, list2)
  len1 = table.getn(list1)
  len2 = table.getn(list2)

  if len1 ~= len2 then
    return false
  end

  for i, line1 in ipairs(list1) do
    if line1 ~= list2[i] then
      return false
    end
  end

  return true
end

local function remove_trailing_blank_line(list)
  -- Remove blank line at the end.
  local length = table.getn(list)
  if list[length] == "" then
    table.remove(list, length)
  end
end

local function run_formatter(formatter)
  local command = formatter.command:gsub("%%", vim.fn.expand("%"))
  util.log("[run_formatter] command", command)

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local result = util.shell(command, {stdin = lines, sync = true})
  util.log("[run_formatter} result", result)
  if result.code == 0 then -- success
    remove_trailing_blank_line(result.stdout)
    if same_lines(lines, result.stdout) then
      print("File already formatted.")
    else
      vim.api.nvim_buf_set_lines(0, 0, -1, false, result.stdout)
    end
    message.close()
  else -- error
    local body = vim.list_extend(result.stderr or {}, result.stdout or {})
    message.show("Formatting Error", body, {mode = "error"})
  end
end

function M.format()
  local filetype = util.buf_get_filetype()
  local formatter = M.formatter_by_filetype[filetype]
  if formatter == nil then
    util.log("[format] no formatter for type", filetype)
    return
  end

  if formatter.command ~= nil then
    run_formatter(formatter)
  elseif formatter.func ~= nil then
    formatter.func()
  end
end

vim.cmd([[
  command! Format lua require("elentok/format2").format()
]])

util.augroup("Format", [[
  autocmd BufWritePre * Format
]])

return M
