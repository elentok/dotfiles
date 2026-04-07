local sources = {
  default = { "lsp", "path", "snippets", "buffer" },
  providers = {},
}

return {
  "saghen/blink.cmp",
  version = "1.*",

  dependencies = {
    "elentok/stuff.nvim",
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "super-tab",

      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
    },
    sources = sources,
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
      keymap = {
        preset = "inherit",
        -- Inheriting the preset causes <c-p> and <c-n> to stop going through history,
        -- this restores that behavior.
        ["<C-p>"] = {
          function() require("stuff.util").sendkeys("<up>") end,
        },
        ["<C-n>"] = {
          function() require("stuff.util").sendkeys("<down>") end,
        },
        ["<Tab>"] = { "show", "accept" },
      },
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
      accept = {
        auto_brackets = { enabled = false },
      },
      -- ghost_text = { enabled = true },
    },
    signature = { enabled = true, window = { border = "rounded" } },
  },
  opts_extend = { "sources.default" },
}
