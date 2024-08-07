local lsp = require("elentok.lib.lsp")

local function typescript_formatter()
  if lsp.hasLspClient("denols") then
    return {} -- fallback to LSP
  else
    return { "prettierd" }
  end
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>oc", "<Cmd>ConformInfo<cr>", desc = "Open conform dialog" },
  },
  opts = {
    format_on_save = function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") or bufname:match(".local/share/nvim/lazy") then
        return
      end

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
        condition = function(_, ctx)
          return vim.fs.basename(ctx.filename) == "layout.md"
        end,
      },
    },
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = typescript_formatter,
      typescriptreact = typescript_formatter,
      javascript = { "prettierd" },
      html = { "prettierd" },
      markdown = { "prettierd", "qmkmd" },
      python = { "black" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      fish = { "fish_indent" },
    },
  },
}
