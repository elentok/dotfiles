local nullLs = require("null-ls")

nullLs.setup({
  sources = {
    nullLs.builtins.diagnostics.shellcheck,
    nullLs.builtins.code_actions.shellcheck
  }
})
