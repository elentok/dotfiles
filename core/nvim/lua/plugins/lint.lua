return {
  "mfussenegger/nvim-lint",
  ft = { "typescript", "typescriptreact" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("Elentok_Lint", {}),
      callback = function() lint.try_lint() end,
    })

    vim.api.nvim_create_user_command("Lint", function() lint.try_lint() end, {})
  end,

  cond = function()
    return vim.fn.findfile("eslint.config.js", ";.") ~= ""
      or vim.fn.findfile(".eslintrc.js", ";.") ~= ""
      or vim.fn.findfile("eslintrc.js", ";.") ~= ""
  end,
}
