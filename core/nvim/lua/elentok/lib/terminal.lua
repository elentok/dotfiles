local FTerm = require("FTerm")

local M = {}

---@param cmd string[]
local function expand_filename(cmd)
  for index, value in ipairs(cmd) do
    if value == "%" then
      cmd[index] = string.format("'%s'", vim.fn.expand(value))
    end
  end
end

---@param cmd string|string[]
---@return string
local function cmd_to_string(cmd)
  if type(cmd) == "table" and vim.tbl_islist(cmd) then
    expand_filename(cmd)
    return table.concat(cmd, " ")
  elseif type(cmd) == "string" then
    return cmd
  end

  error("cmd_to_string expected string or string[]")
end

---@param cmd string|string[]
---@param opts? { w?: number, h?: number, cwd?: string, echo_cmd?: boolean, wait?: boolean }
function M.run(cmd, opts)
  opts = opts or {}
  cmd = cmd_to_string(cmd)

  if opts.echo_cmd then
    cmd = string.format("echo '> %s' && %s", cmd, cmd)
  end

  if opts.wait then
    cmd = string.format("%s; echo '\nPress ENTER to close...'; read", cmd)
  end

  if opts.cwd ~= nil and #opts.cwd > 0 then
    cmd = string.format("echo '> cd %s' && cd '%s' && %s", opts.cwd, opts.cwd, cmd)
  end

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
