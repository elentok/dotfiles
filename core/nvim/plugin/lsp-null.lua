local nullLs = require("null-ls")
local config = require("elentok/config")

local sources = {
  nullLs.builtins.diagnostics.shellcheck,
  nullLs.builtins.code_actions.shellcheck,
  nullLs.builtins.formatting.black,
  nullLs.builtins.formatting.stylua.with({
    extra_args = { "--config-path", vim.fn.expand("$DOTF/core/nvim/stylua.toml") },
  }),
  nullLs.builtins.formatting.shfmt.with({
    extra_args = {"-i", "2", "-bn", "-ci", "-sr"}
  })
}

if config.enable_jsts_prettier then
  table.insert(sources, nullLs.builtins.formatting.prettierd)
else
  table.insert(sources, nullLs.builtins.formatting.prettierd
                   .with({filetypes = {"markdown", "yaml"}}))
end

nullLs.setup({sources = sources})
