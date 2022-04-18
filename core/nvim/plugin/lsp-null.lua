local null_ls = require("null-ls")

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua.with({
      extra_args = {
        "--config-path",
        vim.fn.expand("$DOTF/core/nvim/stylua.toml"),
      },
    }),
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "-i", "2", "-bn", "-ci", "-sr" },
    }),
  },
})
