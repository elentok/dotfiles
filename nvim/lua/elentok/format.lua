local api = vim.api
local util = require('elentok/util')

-- Formatter commands.
local formatter_cmds = {
  black = 'black --quiet --stdin-filename % - 2>/dev/null',
  prettier = 'prettier --stdin-filepath %',
  clang = 'clang-format --style=Google --assume-filename %',
  lsp = function()
    vim.lsp.buf.formatting_seq_sync()
  end,
}

-- Matches filetype to formatter.
local formatter_by_filetype = {
  css = "prettier",
  javascript = "prettier",
  typescript = "prettier",
  typescriptreact = "prettier",
  html = "prettier",
  markdown = "prettier",
  python = "black",
}

-- Enable or disable automatic formatting.
local format_on_save_by_filetype = {
 json = true,
 javascript = true,
 css = true,
 scss = true,
 lua = true,
 typescript = true,
 typescriptreact = true,
 java = true,
 markdown = true,
 yaml = true,
 python = true,
 html = true,
}

local function run_formatter(cmd)
  util.log("[run_formatter] cmd = " .. cmd)
  local cursor = api.nvim_win_get_cursor(0)
  api.nvim_exec('%!' .. cmd, true)
  util.restore_cursor(0, cursor)
end

local function format(formatter)
  if formatter == nil or formatter == '' then
    formatter = formatter_by_filetype[util.buf_get_filetype()] or 'lsp'
  end

  util.log('Formatting with ' .. formatter)
  local cmd = formatter_cmds[formatter]

  if type(cmd) == 'function' then
    cmd()
  else
    run_formatter(cmd)
  end
end

local function format_on_save()
  if format_on_save_by_filetype[util.buf_get_filetype()] then
    format()
  end
end

local function set_formatter_cmd(formatter, cmd)
  formatter_cmds[formatter] = cmd
end

local function set_formatter(filetype, formatter)
  formatter_by_filetype[filetype] = formatter
end

local function set_format_on_save(filetype, enabled)
  if enabled == nil then enabled = true end
  format_on_save_by_filetype[filetype] = enabled
end

vim.cmd([[
  command! -nargs=? Format lua require('elentok/format').format('<args>')
  command! Prettier Format prettier
  command! ClangFormat Format clang
]])

vim.cmd([[
  augroup Elentok_Format
    autocmd!
    autocmd BufWritePre * lua require('elentok/format').format_on_save()
  augroup END
]])

return {
  format = format,
  format_on_save = format_on_save,
  set_formatter_cmd = set_formatter_cmd,
  set_formatter = set_formatter,
  set_format_on_save = set_format_on_save,
}
