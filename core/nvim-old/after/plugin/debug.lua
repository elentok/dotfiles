-- Misc debugging helpers
function _G.PrintSyntaxItems()
  local items = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
  for _, id in ipairs(items) do
    put(vim.fn.synIDattr(id, "name"))
  end
end
