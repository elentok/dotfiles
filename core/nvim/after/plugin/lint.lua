local deno = require("elentok.lib.deno")
local ok, lint = pcall(require, "lint")
if not ok then
  print('Module "lint" not found, skipping setup.')
  return
end

-- local function has_eslintrc()
--   return vim.fn.findfile("eslintrc.js", ";.") ~= "" or vim.fn.findfile(".eslintrc", ";.") ~= ""
-- end

if not deno.isDenoProject() then
  lint.linters_by_ft = {
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
  }
else
  lint.linters_by_ft = {}
end

vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("Elentok_Lint", {}),
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_user_command("Lint", function()
  lint.try_lint()
end, {})

vim.keymap.set("n", "<leader>rl", function()
  lint.try_lint()
  vim.notify("Ran lint")
end, { desc = "Run lint" })
