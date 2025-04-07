---@module 'lspconfig'
---@module 'conform'

local lsp = require("elentok.lsp")

local function typescript_formatter()
  if lsp.has_lsp_client("denols") then
    return {} -- fallback to LSP
  else
    return { "prettierd" }
  end
end

return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        openscad_lsp = {
          cmd = { "openscad-lsp", "--stdio", "--fmt-style", "Google" },
        },
        vtsls = {
          settings = {
            typescript = {
              tsdk = vim.fn.finddir("node_modules/typescript/lib", ".;"),
            },
          },
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- dont show the winbar for some filetypes
      opts.options.disabled_filetypes.winbar = { "dashboard", "lazy", "alpha", "snacks_dashboard" }
      -- remove navic from the statusline
      local navic = table.remove(opts.sections.lualine_c)

      -- add it to the winbar instead
      opts.winbar = { lualine_b = { "filename" }, lualine_c = { navic } }
      opts.inactive_winbar = { lualine_b = { "filename" } }

      table.insert(opts.extensions, require("elentok.lualine-oil-extension"))
    end,
  },

  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        accept = { auto_brackets = { enabled = false } },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    ---@type conform.setupOpts
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
            return vim.endswith(ctx.filename, ".layout.md")
          end,
        },
      },

      formatters_by_ft = {
        typescript = typescript_formatter,
        typescriptreact = typescript_formatter,
        javascript = { "prettierd" },
        html = { "prettierd" },
        markdown = { "prettierd", "qmkmd" },
      },
    },
  },
}
