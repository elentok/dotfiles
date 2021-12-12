local util = require("elentok/util")
local map = require("elentok/map")

local repls = {python = "ipython3", javascript = "node"}

local function send_command(command)
  if vim.t.send_to_term_job_id == nil then
    return
  end
  vim.fn.jobsend(vim.t.send_to_term_job_id, command .. "\n")
end

function _G.TermNew(command)
  vim.cmd([[vsplit | terminal]])
  vim.t.send_to_term_job_id = vim.b.terminal_job_id

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
  send_command(util.get_visual_selection())
end

vim.cmd([[
  command! Tnew lua TermNew()
  command! Trepl lua TermNewRepl()
  command! Tline lua TermSendLine()
  command! -range Tblock lua TermSendBlock()
]])

map.normal("\\\\", ":Tline<cr>")
map.visual("\\\\", ":Tblock<cr>")
