local util = require'elentok/util'

vim.g.autoformat_filetypes = { 'json', 'javascript', 'css', 'scss', 'lua',
  'typescript', 'typescript.tsx', 'java', 'markdown', 'yaml', 'python', 'html' }

function Elentok_AutoFormat ()
  if vim.g.autoformat_disable then
    return
  end

  if vim.tbl_contains(vim.g.autoformat_filetypes, util.buf_get_filetype()) then
    if util.exists(':DotLocalFormat') then
      vim.cmd('DotLocalFormat')
    else
      vim.cmd('Format')
    end
  end
end

vim.cmd([[command! AutoFormat lua Elentok_AutoFormat()]])

vim.cmd([[
  augroup Elentok_Autoformat
    autocmd!
    autocmd BufWritePre * AutoFormat
  augroup END
]])

