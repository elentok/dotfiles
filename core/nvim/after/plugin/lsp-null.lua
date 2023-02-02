local config = require("elentok/config")
local ok, null_ls = pcall(require, "null-ls")
if not ok then
  return
end

local sources = {
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.code_actions.shellcheck,
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
}

if config.enable_prettier then
  table.insert(sources, null_ls.builtins.formatting.prettierd)
end

null_ls.setup({
  debug = true,
  sources = sources,
})
