local M = {}

function M.lua(code)
  return string.format('<Cmd>lua %s<cr>', code)
end

function M.create_map_func(mode, opts)
  if opts == nil then opts = {} end
  if opts.noremap == nil then opts.noremap = true end
  if opts.silent == nil then opts.silent = true end

  return function(lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

M.normal = M.create_map_func('n')
M.visual = M.create_map_func('v')
M.insert = M.create_map_func('i')

return M
