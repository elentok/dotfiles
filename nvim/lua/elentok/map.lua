local M = {}

function M.lua(code)
  return string.format("<Cmd>lua %s<cr>", code)
end

function M.create_map_func(mode, opts)
  opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})

  return function(lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

function M.create_buf_map_func(mode, opts)
  opts = vim.tbl_extend("force", {noremap = true, silent = true}, opts or {})

  return function(lhs, rhs)
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  end
end

M.normal = M.create_map_func("n")
M.visual = M.create_map_func("v")
M.insert = M.create_map_func("i")

M.buf_normal = M.create_buf_map_func("n")
M.buf_visual = M.create_buf_map_func("v")
M.buf_insert = M.create_buf_map_func("i")

return M
