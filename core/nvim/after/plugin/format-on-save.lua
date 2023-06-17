local config = require("elentok/config")
local buf_cursors = require("elentok/lib/buf_cursors")

local function format()
  buf_cursors.save_buf_cursors()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  local opts = config.format_on_save[filetype]
  if opts == nil then
    return
  end

  local filter = nil
  if type(opts) == "string" then
    filter = function(client)
      return client.name == opts
    end
  end

  vim.lsp.buf.format({ timeout_ms = 4000, filter = filter })
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = "*", callback = format })
vim.api.nvim_create_autocmd(
  { "BufWritePost" },
  { pattern = "*", callback = buf_cursors.restore_buf_cursors }
)
vim.api.nvim_create_user_command("Format", format, {})
