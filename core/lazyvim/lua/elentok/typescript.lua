vim.api.nvim_create_user_command("TsServerLog", function()
  LazyVim.lsp.execute({
    command = "typescript.openTsServerLog",
    open = true,
  })
end, {})
