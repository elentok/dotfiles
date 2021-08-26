local api = vim.api

local function lua(code) return string.format('<Cmd>lua %s<cr>', code) end

local function create_map_func(mode, opts)
  if opts == nil then opts = {} end
  if opts.noremap == nil then opts.noremap = true end
  if opts.silent == nil then opts.silent = true end

  return function(lhs, rhs) api.nvim_set_keymap(mode, lhs, rhs, opts) end
end

return {
  lua = lua,
  create_map_func = create_map_func,
  normal = create_map_func('n'),
  visual = create_map_func('v'),
  insert = create_map_func('i')
}
