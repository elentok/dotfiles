local create_cmd = vim.api.nvim_create_user_command
local util = require("elentok/util")

local repls = { python = "ipython3", javascript = "node" }

local function send_command(command)
  if vim.t.send_to_term_job_id == nil then
    return
  end
  vim.fn.jobsend(vim.t.send_to_term_job_id, command .. "\n")
end

local function term_new(command)
  vim.cmd([[vsplit | terminal]])
  vim.t.send_to_term_job_id = vim.b.terminal_job_id

  if command ~= nil then
    send_command(command)
  end
end

local function term_new_repl()
  local filetype = util.buf_get_filetype(0)
  local repl = repls[filetype]
  term_new(repl)
end

local function term_send_line()
  send_command(vim.fn.getline("."))
end

local function term_send_block()
  send_command(util.get_visual_selection())
end

create_cmd("Tnew", function(args)
  term_new(args.args)
end, {})
create_cmd("Trepl", term_new_repl, {})
create_cmd("Tline", term_send_line, {})
create_cmd("Tblock", term_send_block, { range = true })

vim.keymap.set("n", "\\\\", ":Tline<cr>")
vim.keymap.set("v", "\\\\", ":Tblock<cr>")
