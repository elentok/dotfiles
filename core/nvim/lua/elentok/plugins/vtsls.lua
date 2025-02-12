return {
  "yioneko/nvim-vtsls",
  ft = { "typescript", "typescriptreact", "javascript" },
  init = function()
    -- Organize imports before saving
    -- vim.api.nvim_create_autocmd(
    --   { "BufWritePre" },
    --   { pattern = { "*.ts", "*.tsx", "*.js" }, command = "VtsExec organize_imports" }
    -- )
  end,
  keys = {
    "<leader>oi",
    "VtsExec organize_imports",
  },
}
