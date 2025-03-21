if vim.g.vscode then
  return {
    run = function()
      print("elentok.lib.terminal is not implemented in vscode mode")
    end,
  }
end

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
  if type(cmd) == "table" and vim.islist(cmd) then
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
---@field on_open? fun(term:Terminal)
---@field ctrl_z_closes? boolean (defaults to true)

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

  if opts.cwd ~= nil and #opts.cwd > 0 then
    cmd = string.format("echo '> cd %s' && cd '%s' && %s", opts.cwd, opts.cwd, cmd)
  end

  ---@param trm Terminal
  local on_open = function(trm)
    if opts.ctrl_z_closes ~= false then
      vim.keymap.set({ "i", "t", "n" }, "<c-z>", "<cmd>close<cr>", { buffer = trm.bufnr })
    end
    if opts.on_open then
      opts.on_open(trm)
    end
  end

  local t = Terminal:new({
    cmd = cmd,
    close_on_exit = not opts.wait,
    on_exit = opts.on_exit,
    on_close = opts.on_close,
    on_open = on_open,
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
