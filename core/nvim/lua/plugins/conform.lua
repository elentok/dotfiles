local utils = require("elentok.utils")

local function typescript_formatter()
  if utils.hasfile({ "deno.json", "deno.jsonc" }) then
    -- fallback deno LSP
    return {}
  else
    return { "prettierd" }
  end
end

local function markdown_formatter()
  if utils.hasfile({ "dprint.json", "dprint.jsonc", ".dprint.json", ".dprint.jsonc" }) then
    -- fallback to dprint LSP
    return { "qmkmd", lsp_format = "first" }
  else
    return { "prettierd", "qmkmd" }
  end
end

-- for debugging purposes
_G.typescript_formatter = typescript_formatter
_G.markdown_formatter = markdown_formatter

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
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
      typescript = typescript_formatter,
      typescriptreact = typescript_formatter,
      javascript = { "prettierd" },
      html = { "prettierd" },
      markdown = markdown_formatter,
      fish = { "fish_indent" },
    },
  },
}
