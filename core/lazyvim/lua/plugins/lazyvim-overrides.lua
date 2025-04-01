-- Find the absolute path to the local project's tsserver (to avoid using the
-- version embedded with vtsls)
local function find_local_tsserver()
  local root_dir = require("lspconfig.util").root_pattern("node_modules/typescript/lib")(vim.uv.cwd())
  if root_dir == nil then
    return nil
  end

  return root_dir .. "/node_modules/typescript/lib"
end

---@module 'lspconfig'
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
              tsdk = find_local_tsserver(),
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
}
