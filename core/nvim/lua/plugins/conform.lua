local typescript_env = require("elentok.typescript-env")

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  ---@type conform.setupOpts
  opts = {
    format_on_save = function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") or bufname:match(".local/share/nvim/lazy") then return end

      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,

    formatters = {
      qmkmd = {
        command = "qmkmd",
        args = { "format", "$FILENAME" },
        stdin = false,
        condition = function(_, ctx) return vim.endswith(ctx.filename, ".layout.md") end,
      },
    },

    formatters_by_ft = {
      lua = { "stylua" },
      typescript = typescript_env.formatter,
      typescriptreact = typescript_env.formatter,
      javascript = { "prettierd" },
      html = { "prettierd" },
      markdown = { "prettierd", "qmkmd" },
    },
  },
}
