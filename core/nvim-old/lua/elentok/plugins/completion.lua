local ai = require("elentok.lib.ai")

---@type string[]
local default_sources = { "lsp", "path", "snippets", "buffer", "emoji" }

---@type table<string, blink.cmp.SourceProviderConfigPartial>?
local providers = {
  lsp = {
    score_offset = 10,
  },
  emoji = {
    name = "emoji",
    module = "blink.compat.source",
    -- overwrite kind of suggestion
    transform_items = function(_, items)
      local kind = require("blink.cmp.types").CompletionItemKind.Text
      for i = 1, #items do
        items[i].kind = kind
      end
      return items
    end,
  },
  -- ripgrep = {
  --   module = "blink-ripgrep",
  --   name = "rg",
  -- },
}

if ai.allow then
  -- if false then
  table.insert(default_sources, "minuet")
  providers.minuet = {
    name = "minuet",
    module = "minuet.blink",
    score_offset = 100,
    async = true,
  }

  table.insert(default_sources, "copilot")
  providers.copilot = {
    name = "copilot",
    module = "blink-cmp-copilot",
    score_offset = 100,
    async = true,
  }
end

---@module "lazy"
---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      -- {
      --   "L3MON4D3/LuaSnip",
      --   version = "v2.*",
      --   -- install jsregexp (optional!).
      --   build = "make install_jsregexp",
      --   dependencies = "rafamadriz/friendly-snippets",
      --   config = function()
      --     require("luasnip.loaders.from_vscode").lazy_load()
      --     require("luasnip.loaders.from_snipmate").lazy_load()
      --   end,
      -- },
      -- "rafamadriz/friendly-snippets",
      -- "mikavilpas/blink-ripgrep.nvim",
      "giuxtaposition/blink-cmp-copilot",
      "allaman/emoji.nvim",
      "milanglacier/minuet-ai.nvim",
      "saghen/blink.compat", -- required for emoji
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    config = function()
      require("blink.cmp").setup({
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- See the full "keymap" documentation for information on defining your own keymap.
        -- keymap = { preset = "default" },
        keymap = {
          preset = "super-tab",

          -- Manually invoke minuet completion.
          ["<A-y>"] = require("minuet").make_blink_map(),
          -- ["<cr>"] = { "accept", "fallback" },
          -- ["<Tab>"] = {
          --   function(cmp)
          --     if cmp.snippet_active() then
          --       return cmp.accept()
          --     else
          --       return cmp.select_next()
          --     end
          --     -- else return cmp.select_and_accept() end
          --   end,
          --   "snippet_forward",
          --   "fallback",
          -- },
        },

        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = false,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        completion = {
          -- Recommended to avoid unnecessary request
          trigger = { prefetch_on_insert = false },
          menu = {
            draw = {
              columns = {
                { "kind_icon", gap = 1 },
                { "label" },
                -- { "label", "label_description", gap = 1 },
                -- { "kind_icon", "kind" },
                { "source_name" },
              },
            },
          },

          -- This is a bit jumpy
          -- ghost_text = {
          --   enabled = true,
          -- },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },

        sources = {
          default = default_sources,
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
          providers = providers,
        },

        -- opts_extend = { "sources.default" },
      })
    end,

    -- Old nvim-cmp plugins:
    -- "hrsh7th/nvim-cmp",
    -- "hrsh7th/cmp-nvim-lsp",
    -- "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-path",
    -- "hrsh7th/cmp-nvim-lua",
    -- "hrsh7th/cmp-cmdline",
    -- "lukas-reineke/cmp-rg",
    -- "saadparwaiz1/cmp_luasnip",
    -- "onsails/lspkind-nvim",
    -- "rafamadriz/friendly-snippets",
  },
}
