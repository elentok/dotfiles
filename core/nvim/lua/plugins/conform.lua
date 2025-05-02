local function typescript_formatter()
  if vim.fn.findfile("deno.jsonc", ".;") ~= "" or vim.fn.findfile("deno.json", ".;") ~= "" then
    -- fallback to LSP
    return {}
  else
    return { "prettierd" }
  end
end

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
      markdown = { "prettierd", "qmkmd" },
      fish = { "fish_indent" },
    },
  },
}
