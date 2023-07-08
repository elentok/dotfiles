local FTerm = require("FTerm")

local M = {}

function M.run(cmd, opts)
  opts = opts or {}

  local t = FTerm:new({
    cmd = cmd,
    dimensions = {
      height = opts.h or 0.9,
      width = opts.w or 0.9,
    },
  })

  t:open()
end

return M
