local lspconfig = require("lspconfig")
local config = require("elentok/config")
local filetypes = {"sh", "python", "lua", "css", "html", "markdown"}

if config.enable_jsts_prettier then
  vim.list_extend(filetypes, {"javascript", "typescript", "typescriptreact"})
end

lspconfig.diagnosticls.setup {
  filetypes = filetypes,
  init_options = {
    filetypes = {sh = "shellcheck"},
    formatFiletypes = {
      sh = "shfmt",
      python = "black",
      lua = "luaformat",
      css = "prettierd",
      html = "prettierd",
      javascript = "prettierd",
      markdown = "prettierd",
      typescript = "prettierd",
      typescriptreact = "prettierd"
    },
    linters = {
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = {"--format", "json", "-"},
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint"
        }
      }
    },
    formatters = {
      shfmt = {command = "shfmt", args = {"-i", "2", "-bn", "-ci", "-sr"}},
      black = {command = "black", args = {"--quiet", "-"}},
      luaformat = {
        command = "lua-format",
        args = {"--config=" .. vim.env.HOME .. "/.lua-format"}
      },
      prettierd = {command = "prettierd", args = {"%filename"}}
    }
  }
}
