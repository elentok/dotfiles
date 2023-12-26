local is_dev_mode = require('elentok.lib.dev-mode')

---@param name string
---@return boolean
local function hasLspClient(name)
  return #vim.tbl_filter(function(client)
    return client.name == name
  end, vim.lsp.buf_get_clients()) > 0
end

return {
  "elentok/format-on-save.nvim",
  dev = is_dev_mode,
  config = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")
    local message_buffer = require("format-on-save.error-notifiers.message-buffer")
    local config = require("elentok.config")

    local function typescript_formatter()
      if hasLspClient("denols") then
        return formatters.lsp
      else
        return formatters.prettierd
      end
    end

    local function markdown_kb_layout_formatter()
      if vim.fn.expand("%:t"):match("layout.md") then
        return formatters.shell({ cmd = { "qmkmd", "format", "%" }, tempfile = "random" })
      end
    end

    format_on_save.setup({
      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },
      experiments = {
        partial_update = "line-by-line",
        -- disable_restore_cursors = false,
        adjust_cursor_position = true,
      },
      formatter_by_ft = vim.tbl_extend("force", {
        css = formatters.lsp,
        html = formatters.prettierd,
        java = formatters.lsp,
        javascript = formatters.prettierd,
        json = formatters.lsp,
        lua = formatters.stylua,
        markdown = {
          formatters.prettierd,
          markdown_kb_layout_formatter,
        },
        openscad = formatters.lsp,
        python = formatters.black,
        rust = formatters.lsp,
        scad = formatters.lsp,
        scss = formatters.lsp,
        sh = formatters.shfmt,
        zsh = formatters.shfmt,
        terraform = formatters.lsp,
        typescript = typescript_formatter,
        typescriptreact = typescript_formatter,
        yaml = formatters.lsp,
      }, config.formatter_by_ft),
    })
  end,
}
