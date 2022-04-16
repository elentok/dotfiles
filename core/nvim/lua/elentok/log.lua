local create_cmd = vim.api.nvim_create_user_command
local log_enabled = vim.env.NVIM_LOG == "true"

local M = {}

function M.set_log(enabled)
  log_enabled = enabled
end

function M.log(...)
  if log_enabled then
    put(...)
  end
end

create_cmd("LogEnable", function()
  M.set_log(true)
end, {})

create_cmd("LogDisable", function()
  M.set_log(false)
end, {})

return M
