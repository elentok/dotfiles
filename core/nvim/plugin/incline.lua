local ok, incline = pcall(require, "incline")

if not ok then
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
  highlight InclineNormal guifg=202020
  highlight InclineNormalNC guifg=707070
]])
