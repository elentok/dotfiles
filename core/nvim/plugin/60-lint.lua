local loaded = false

local function load_nvim_lint()
  if loaded then return end
  loaded = true

  local lint = require("nvim-lint")

  lint.linters_by_ft = {
    groovy = { "npm-groovy-lint" },
    -- typescript = { "eslint_d" },
    -- typescriptreact = { "eslint_d" },
  }

  vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
    group = vim.api.nvim_create_augroup("Elentok_Lint", {}),
    callback = function() lint.try_lint() end,
  })

  vim.api.nvim_create_user_command("Lint", function() lint.try_lint() end, {})
  --
  --   -- cond = function()
  --   --   return vim.fn.findfile("eslint.config.js", ";.") ~= ""
  --   --     or vim.fn.findfile(".eslintrc.js", ";.") ~= ""
  --   --     or vim.fn.findfile("eslintrc.js", ";.") ~= ""
  --   --     or vim.fn.findfile(".eslintrc.json", ";.") ~= ""
  --   -- end,
  -- })
end

vim.api.nvim_create_autocmd("FileType", {
  -- pattern = { "typescript", "typescriptreact", "groovy" },
  pattern = { "groovy" },
  callback = load_nvim_lint,
})
