return {
  "elentok/format-on-save.nvim",
  dev = true,
  config = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")
    local message_buffer = require("format-on-save.error-notifiers.message-buffer")
    local config = require("elentok.config")

    format_on_save.setup({
      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },
      experiments = {
        partial_update = "diff",
        disable_restore_cursors = false,
      },
      error_notifier = message_buffer,
      formatter_by_ft = vim.tbl_extend("force", {
        css = formatters.lsp,
        html = formatters.lsp,
        java = formatters.lsp,
        javascript = formatters.prettierd,
        json = formatters.lsp,
        lua = formatters.stylua,
        markdown = formatters.prettierd,
        openscad = formatters.lsp,
        python = formatters.black,
        rust = formatters.lsp,
        scad = formatters.lsp,
        scss = formatters.lsp,
        sh = formatters.shfmt,
        zsh = formatters.shfmt,
        terraform = formatters.lsp,
        typescript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        yaml = formatters.lsp,
      }, config.formatter_by_ft),
    })
  end,
}
