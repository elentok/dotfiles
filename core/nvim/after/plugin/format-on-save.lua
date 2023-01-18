local config = require("elentok/config")

local function format()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if vim.tbl_contains(config.format_on_save, filetype) then
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = "*", callback = format })
vim.api.nvim_create_user_command("Format", format, {})
