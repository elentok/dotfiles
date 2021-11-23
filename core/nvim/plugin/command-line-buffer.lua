local util = require("elentok/util")
local map = require("elentok/map")

function _G.setup_command_line_buffer()
  map.buf_normal(0, "q", ":q<cr>")
end

util.augroup("CommandLineBuffer", [[
  autocmd CmdwinEnter * lua setup_command_line_buffer()
]])
