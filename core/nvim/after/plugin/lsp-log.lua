vim.api.nvim_create_user_command("LspLog", ":tabe " .. vim.lsp.get_log_path(), {})
vim.api.nvim_create_user_command("LspDebugOn", function()
  vim.lsp.set_log_level(1)
end, {})
vim.api.nvim_create_user_command("LspDebugOff", function()
  vim.lsp.set_log_level(3)
end, {})
