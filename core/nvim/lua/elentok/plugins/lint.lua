local function has_eslint_module()
  return vim.fn.findfile(".eslintrc.js", ";.") ~= ""
    or vim.fn.finddir("node_modules/eslint", ";.") ~= ""
end

return {
  "mfussenegger/nvim-lint",
  lazy = true,
  ft = { "typescript", "typescriptreact" },
  config = function()
    local lint = require("lint")

    if has_eslint_module() then
      lint.linters_by_ft = {
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
    else
      lint.linters_by_ft = {}
    end

    lint.linters_by_ft["fish"] = { "fish" }
    lint.linters_by_ft["markdown"] = { "markdownlint-cli2" }

    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("Elentok_Lint", {}),
      callback = function()
        lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, {})
  end,

  cmd = "Lint",
  keys = {
    {
      "<leader>rl",
      function()
        require("lint").try_lint()
        vim.notify("Ran lint")
      end,
      desc = "Run lint",
    },
  },
}
