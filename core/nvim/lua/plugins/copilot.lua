vim.g.copilot_node = vim.fn.executable("/opt/homebrew/bin/node") == 1 and "/opt/homebrew/bin/node"
  or nil

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  cond = require("elentok.ai").allow,
  opts = {
    copilot_node_command = vim.g.copilot_node,
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
    server = {
      type = "binary",
    },
  },
}
