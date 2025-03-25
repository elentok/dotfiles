local prefix = "[bazinga]"
local ui = require("elentok.ui")

local function get_logger_line()
  local context = "L" .. vim.fn.line(".")
  local filename = vim.fn.expand("%:t")

  local log = prefix .. " [" .. filename .. "] " .. context

  local filetype = vim.bo.filetype
  if filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascript" then
    return "console.log('" .. log .. "')"
  elseif filetype == "lua" then
    return "put('" .. log .. "')"
  elseif filetype == "sh" then
    return 'echo "' .. log .. '"'
  else
    return ""
  end
end

vim.keymap.set("i", "<c-l>", function()
  vim.api.nvim_put({ get_logger_line() }, "c", true, true)
  ui.feedkeys("<Left>")
end)
