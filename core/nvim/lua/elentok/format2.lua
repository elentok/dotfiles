local util = require("elentok/util")
-- local Job = require("plenary.job")

local M = {}

M.formatters = {}
M.formatter_by_filetype = {}

function M.add_formatter(name, formatter)
  M.formatters[name] = formatter

  for _, filetype in formatter.filetypes do
    M.formatter_by_filetype[filetype] = formatter
  end

end

M.add_formatter("black", {
  command = "black",
  args = {"--quiet", "--stdin-filename", "%", "-"},
  filetypes = {"python"}
})

M.add_formatter("clang", {
  command = "clang-format",
  args = {"--style=Google", "--assume-filename", "%"}
})
M.add_formatter("luaformat", {
  command = "lua-format",
  args = {"--config=$HOME/.lua-format"},
  filetypes = {"lua"}
})

M.add_formatter("prettier", {
  command = "prettierd",
  args = {"%"},
  filetypes = {
    "css", "html", "javascript", "json", "markdown", "typescript",
    "typescriptreact"
  }
})

M.add_formatter("lsp", {
  func = function()
    vim.lsp.buf.formatting_seq_sync()
  end,
  filetypes = {"scss", "sh", "java", "yaml"}
})

function M.format(formatter_name)
  local formatter
  if formatter_name == nil then
    formatter = M.formatter_by_filetype[util.buf_get_filetype()]
  else
    formatter = M.formatters[formatter_name]
  end

  put(formatter)
end

return M
