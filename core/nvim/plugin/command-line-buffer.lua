local util = require("elentok/util")

function _G.setup_command_line_buffer()
  vim.keymap.set("n", "q", ":q<cr>", { buffer = true })
end

util.augroup(
  "CommandLineBuffer",
  [[
  autocmd CmdwinEnter * lua setup_command_line_buffer()
]]
)
