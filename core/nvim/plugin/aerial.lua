local map = require("elentok/map")
local aerial = require("aerial")

aerial.register_attach_cb(function(bufnr)
  map.buf_normal(bufnr, "<Leader>ta", "<cmd>AerialToggle!<cr>")
  map.buf_normal(bufnr, "[[", "<cmd>AerialPrev<cr>")
  map.buf_normal(bufnr, "]]", "<cmd>AerialNext<cr>")
end)

vim.cmd([[hi link AerialLine DiffAdd]])