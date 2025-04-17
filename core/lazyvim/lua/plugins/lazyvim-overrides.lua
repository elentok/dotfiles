---@module 'lspconfig'
---@module 'conform'

local typescript_env = require("elentok.typescript-env")

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
        eslint = {
          enabled = false,
        },
        denols = {
          mason = false,
          enabled = typescript_env.mode == "deno",
        },
        vtsls = {
          enabled = typescript_env.mode == "node",
          settings = {
            typescript = {
              tsdk = vim.fn.finddir("node_modules/typescript/lib", ".;"),
            },
          },
        },
        harper_ls = {},
      },
    },
  },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "harper-ls",
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
        typescript = typescript_env.formatter,
        typescriptreact = typescript_env.formatter,
        javascript = { "prettierd" },
        html = { "prettierd" },
        markdown = { "prettierd", "qmkmd" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        typescript = typescript_env.linters,
        typescriptreact = typescript_env.linters,
        markdown = {},
      },
    },
  },
}
