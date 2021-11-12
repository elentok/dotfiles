local util = require("elentok/util")
local message = require("elentok/message")

local M = {}

local formatters = {}
local formatter_by_filetype = {}

function M.add_formatter(name, formatter)
  formatters[name] = formatter

  for _, filetype in ipairs(formatter.filetypes or {}) do
    formatter_by_filetype[filetype] = formatter
  end
end

function M.assign_formatter(name, filetypes)
  local formatter = formatters[name]
  if formatter == nil then
    print("Error: no formatter named " .. name)
    return
  end

  for _, filetype in ipairs(filetypes) do
    formatter_by_filetype[filetype] = formatter
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

M.add_formatter("shfmt",
                {command = "shfmt -i 2 -bn -ci -sr", filetypes = {"sh"}})

M.add_formatter("lsp", {
  func = function()
    vim.lsp.buf.formatting_seq_sync()
  end,
  filetypes = {"scss", "java", "yaml"}
})

local function same_lines(list1, list2)
  local len1 = table.getn(list1)
  local len2 = table.getn(list2)

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
  local formatter = formatter_by_filetype[filetype]
  if formatter == nil then
    util.log("[format] no formatter for type", filetype)
    return
  end

  util.log("[format] formatter for type", filetype, formatter)
  if formatter.command ~= nil then
    run_formatter(formatter)
  elseif formatter.func ~= nil then
    formatter.func()
  end
end

vim.cmd([[
  command! Format lua require("elentok/format").format()
]])

util.augroup("Format", [[
  autocmd BufWritePre * Format
]])

-- Keeping these functions here in case I think about bringing this
-- functionality back soon:
-- local function save_views(bufnr)
--   local active_winhandle = vim.api.nvim_tabpage_get_win(0)
--   for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
--     local winnr = vim.api.nvim_win_get_number(winhandle)
--     vim.cmd(winnr .. "wincmd w")
--     vim.w.last_view = vim.fn.winsaveview()

--     if active_winhandle ~= winhandle then
--       vim.cmd("wincmd p")
--     end
--   end
-- end

-- local function restore_views(bufnr)
--   local active_winhandle = vim.api.nvim_tabpage_get_win(0)
--   for _, winhandle in ipairs(vim.fn.win_findbuf(bufnr)) do
--     local winnr = vim.api.nvim_win_get_number(winhandle)
--     vim.cmd(winnr .. "wincmd w")
--     if vim.w.last_view then
--       vim.fn.winrestview(vim.w.last_view)
--     else
--       put(
--           "Warning: missing window view setting: bufnr=" .. bufnr .. ", winnr=" ..
--               winnr)
--     end

--     if active_winhandle ~= winhandle then
--       vim.cmd("wincmd p")
--     end
--   end
-- end

return M
