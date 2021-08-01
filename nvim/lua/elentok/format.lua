local api = vim.api
local util = require('elentok/util')

-- Matches filetype to formatter.
local formatters = {
  css = "prettier",
  javascript = "prettier",
  typescript = "prettier",
  typescriptreact = "prettier",
  html = "prettier",
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

local function prettier()
  local cursor = api.nvim_win_get_cursor(0)
  api.nvim_exec('%!prettier --stdin-filepath %', true)
  util.restore_cursor(0, cursor)
end

local function clang()
  local cursor = api.nvim_win_get_cursor(0)
  api.nvim_exec('%!clang-format --style=Google --assume-filename %', true)
  util.restore_cursor(0, cursor)
end

local function format(formatter)
  formatter = formatter or formatters[util.buf_get_filetype()]

  if formatter == 'clang' then
    util.log('Formatting with clang.')
    clang()
  elseif formatter == 'prettier' then
    util.log('Formatting with prettier.')
    prettier()
  else
    util.log('Formatting with LSP.')
    vim.lsp.buf.formatting_seq_sync()
  end
end

local function format_on_save()
  if format_on_save_by_filetype[util.buf_get_filetype()] then
    format()
  end
end

local function set_formatter(filetype, formatter)
  formatters[filetype] = formatter
end

local function set_format_on_save(filetype, enabled)
  if enabled == nil then enabled = true end
  format_on_save_by_filetype[filetype] = enabled
end

vim.cmd([[
  command! Prettier lua require('elentok/format').prettier()
  command! ClangFormat lua require('elentok/format').clang()
  command! Format lua require('elentok/format').format()
]])

vim.cmd([[
  augroup Elentok_Format
    autocmd!
    autocmd BufWritePre * lua require('elentok/format').format_on_save()
  augroup END
]])

return {
  clang = clang,
  format = format,
  format_on_save = format_on_save,
  prettier = prettier,
  set_formatter = set_formatter,
  set_format_on_save = set_format_on_save,
}
