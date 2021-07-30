local api = vim.api
local util = require('elentok/util')

local formatters = {
  css = "prettier",
  javascript = "prettier",
  typescript = "prettier",
  typescriptreact = "prettier",
  html = "prettier",
}

local function prettier()
  cursor = api.nvim_win_get_cursor(0)
  api.nvim_exec('%!prettier --stdin-filepath %', true)
  util.restore_cursor(0, cursor)
end

local function clang()
  cursor = api.nvim_win_get_cursor(0)
  api.nvim_exec('%!clang-format --style=Google --assume-filename %', true)
  util.restore_cursor(0, cursor)
end

local function format()
  local formatter = formatters[util.buf_get_filetype()]

  if formatter == 'clang' then
    clang()
  elseif formatter == 'prettier' then
    prettier()
  else
    vim.lsp.buf.formatting_seq_sync()
  end
end

vim.cmd([[
  command! Prettier lua require('elentok/format').prettier()
  command! ClangFormat lua require('elentok/format').clang()
  command! Format lua require('elentok/format').format()
]])

return {
  clang = clang,
  format = format,
  prettier = prettier,
}
