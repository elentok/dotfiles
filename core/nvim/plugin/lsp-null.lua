local nullLs = require("null-ls")

nullLs.setup({
  sources = {
    nullLs.builtins.diagnostics.shellcheck,
    nullLs.builtins.code_actions.shellcheck,
    nullLs.builtins.formatting.black,
    nullLs.builtins.formatting.lua_format,
    nullLs.builtins.formatting.prettierd,
    nullLs.builtins.formatting.shfmt.with({
      extra_args = {"-i", "2", "-bn", "-ci", "-sr"}
    })
  }
})
