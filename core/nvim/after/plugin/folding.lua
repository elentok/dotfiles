local util = require("elentok/util")

-- After saving a buffer run "zv" to make sure current line isn't folded.
util.augroup(
  "Folding",
  [[
  autocmd BufWritePost * normal! zv
]]
)
