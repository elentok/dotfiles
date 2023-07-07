local FTerm = require("FTerm")

local M = {}

function M.run(cmd)
  local t = FTerm:new({
    cmd = cmd,
  })

  t:open()
end

return M
