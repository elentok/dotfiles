local lspconfig = require("lspconfig")

lspconfig.diagnosticls.setup {
  filetypes = {
    "sh", "python", "lua", "css", "html", "javascript", "markdown",
    "typescript", "typescriptreact"
  },
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
