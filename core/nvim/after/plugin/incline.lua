local ok, incline = pcall(require, "incline")

if not ok then
  return
end

-- Neovim 0.8 has a built-in winbar
if vim.fn.has("nvim-0.8") == 1 then
  return
end

incline.setup({
  window = {
    margin = {
      vertical = 0, -- show on the separator line
    },
  },
})

vim.cmd([[
  highlight InclineNormal guibg=#202020
  highlight InclineNormalNC guibg=#404040
]])