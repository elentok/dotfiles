local util = require("elentok/util")
local map = require("elentok/map")

local repls = {python = "ipython3", javascript = "node"}

local terminal_job_id
-- local function set_default_terminal()
--   terminal_job_id = vim.b.terminal_job_id
-- end
--
local function send_command(command)
  if terminal_job_id == nil then
    return
  end
  vim.fn.jobsend(terminal_job_id, command .. "\n")
end

function _G.TermNew(command)
  vim.cmd([[vsplit | terminal]])
  terminal_job_id = vim.b.terminal_job_id

  if command ~= nil then
    send_command(command)
  end
end

function _G.TermNewRepl()
  local filetype = util.buf_get_filetype(0)
  local repl = repls[filetype]
  TermNew(repl)
end

function _G.TermSendLine()
  send_command(vim.fn.getline("."))
end

function _G.TermSendBlock()
  -- vim.cmd([[noau normal! "wy]])
  -- vim.fn.feedkeys([["ty]], "n")
  -- vim.fn.feedkeys("", "nx")
  local keys = vim.api.nvim_replace_termcodes([["ty]], true, true, true)
  vim.api.nvim_feedkeys(keys, "nx", true)
  put(vim.fn.getreg("t"))
  send_command(vim.fn.getreg("t"))
end

vim.cmd([[
  command! Tnew lua TermNew()
  command! Trepl lua TermNewRepl()
  command! Tline lua TermSendLine()
  command! -range Tblock lua TermSendBlock()
]])

map.normal("\\\\", ":Tline<cr>")
map.visual("\\\\", ":Tblock<cr>")
