local util = require("elentok/util")
local message = require("elentok/message")

local M = {}

-- Formatter commands.
local formatter_cmds = {
  black = "black --quiet --stdin-filename % - 2>/dev/null",
  clang = "clang-format --style=Google --assume-filename %",
  luaformat = vim.fn.expand("lua-format --config=$HOME/.lua-format"),
  prettier = "prettier --stdin-filepath %",
  lsp = function()
    vim.lsp.buf.formatting_seq_sync()
  end
}

-- TODO:
-- verify formatter commands are executable.
-- for formatter, cmd in pairs(formatter_cmds) do print(formatter) end

-- Matches filetype to formatter.
local formatter_by_filetype = {
  css = "prettier",
  html = "prettier",
  javascript = "prettier",
  lua = "luaformat",
  markdown = "prettier",
  python = "black",
  typescript = "prettier",
  typescriptreact = "prettier"
}

-- Enable or disable automatic formatting.
local format_on_save_by_filetype = {
  css = true,
  html = true,
  java = true,
  javascript = true,
  json = true,
  lua = true,
  markdown = true,
  python = true,
  scss = true,
  sh = true,
  typescript = true,
  typescriptreact = true,
  yaml = true
}

local function run_formatter(cmd)
  util.log("[run_formatter] cmd = ", cmd)
  local cursor = vim.fn.getpos(".")

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  util.shell(cmd, {
    stdin = lines,
    callback = function(exitcode, stdin, stderr)
      if exitcode ~= 0 then
        put("Error formatting:", stderr[1])
        message.show("Formatting Error", stderr, {mode = "error"})
      else
        put("Formatted successfuly.")
        message.close()

        vim.api.nvim_buf_set_lines(0, 0, -1, false, stdin)
        vim.cmd("noautocmd w")
        vim.fn.setpos(".", cursor)
      end
    end
  })
end

function M.format(formatter)
  if formatter == nil or formatter == "" then
    formatter = formatter_by_filetype[util.buf_get_filetype()] or "lsp"
  end

  util.log("Formatting with " .. formatter)
  local cmd = formatter_cmds[formatter]

  if type(cmd) == "function" then
    cmd()
  else
    run_formatter(cmd)
  end
end

function M.format_on_save()
  if format_on_save_by_filetype[util.buf_get_filetype()] then
    M.format()
  end
end

function M.set_formatter_cmd(formatter, cmd)
  formatter_cmds[formatter] = cmd
end

function M.set_formatter(filetype, formatter)
  formatter_by_filetype[filetype] = formatter
end

function M.set_format_on_save(filetype, enabled)
  if enabled == nil then
    enabled = true
  end
  format_on_save_by_filetype[filetype] = enabled
end

vim.cmd([[
  command! -nargs=? Format lua require('elentok/format').format('<args>')
  command! Prettier Format prettier
  command! ClangFormat Format clang
]])

util.augroup("Format", [[
  autocmd BufWritePost * lua require('elentok/format').format_on_save()
]])

return M

