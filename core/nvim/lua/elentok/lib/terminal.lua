local term = require("toggleterm.terminal")
local Terminal = term.Terminal

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

---@class TermRunOptions
---@field w? number
---@field h? number
---@field cwd? string
---@field echo_cmd? boolean
---@field wait? boolean
---@field on_exit? fun(t: Terminal, job: number, exit_code: number, name: string)
---@field on_close? fun(t: Terminal)

---@param cmd string|string[]
---@param opts? TermRunOptions
function M.run(cmd, opts)
  opts = opts or {}

  if opts.wait == nil then
    opts.wait = true
  end

  cmd = cmd_to_string(cmd)

  if opts.echo_cmd then
    cmd = string.format("echo '> %s' && %s", cmd, cmd)
  end

  -- if opts.wait then
  --   cmd = string.format("%s; echo '\nPress ENTER to close...'; read", cmd)
  -- end

  if opts.cwd ~= nil and #opts.cwd > 0 then
    cmd = string.format("echo '> cd %s' && cd '%s' && %s", opts.cwd, opts.cwd, cmd)
  end

  local t = Terminal:new({
    cmd = cmd,
    close_on_exit = not opts.wait,
    on_exit = opts.on_exit,
    on_close = opts.on_close,
    hidden = false,
    float_opts = {
      width = opts.w,
      height = opts.h,
    },
  })

  t:open()
  return t
end

return M
