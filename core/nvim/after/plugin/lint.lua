local lint = require("lint")

-- local function has_eslintrc()
--   return vim.fn.findfile("eslintrc.js", ";.") ~= "" or vim.fn.findfile(".eslintrc", ";.") ~= ""
-- end

lint.linters_by_ft = {
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("Elentok_Lint", {}),
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_user_command("Lint", function()
  lint.try_lint()
end, {})

vim.keymap.set("n", "<space>rl", function()
  lint.try_lint()
  vim.notify("Ran lint")
end, { desc = "Run lint" })