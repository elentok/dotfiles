local config = require("elentok/config")

local function format()
  vim.lsp.buf.format({ timeout_ms = 4000 })
end

local function format_on_save()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if vim.tbl_contains(config.format_on_save, filetype) then
    format()
  end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = "*", callback = format_on_save })
vim.api.nvim_create_user_command("Format", format, {})
