local config = require("elentok/config")
local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local sources = {
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.code_actions.shellcheck,
  null_ls.builtins.formatting.prettierd.with({
    disabled_filetypes = config.prettierd_disabled_filetypes,
  }),
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.stylua.with({
    extra_args = {
      "--config-path",
      vim.fn.expand("$DOTF/core/nvim/stylua.toml"),
    },
  }),
  null_ls.builtins.formatting.shfmt.with({
    extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
  }),
  require("typescript.extensions.null-ls.code-actions"),
}

local function has_eslintrc()
  return vim.fn.findfile(".eslintrc", ";.") ~= ""
end

if has_eslintrc() then
  table.insert(sources, null_ls.builtins.diagnostics.eslint_d)
  table.insert(sources, null_ls.builtins.code_actions.eslint_d)

  if config.enable_eslint_formatter then
    table.insert(sources, null_ls.builtins.formatting.eslint_d)
  end
end

null_ls.setup({
  debug = true,
  sources = sources,
})
