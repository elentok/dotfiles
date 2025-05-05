local allow_ai = require("elentok.ai").allow
local sources = {
  default = { "lsp", "path", "snippets", "buffer" },
  providers = {},
}

if allow_ai then
  vim.list_extend(sources.default, { "copilot" })
  sources.providers.copilot = {
    name = "copilot",
    module = "blink-copilot",
    score_offset = 100,
    async = true,
  }
end

return {
  "saghen/blink.cmp",
  version = "1.*",

  dependencies = {
    {
      "fang2hou/blink-copilot",
      cond = allow_ai,
    },
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
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      -- ghost_text = { enabled = true },
    },
    signature = { enabled = true },
  },
  opts_extend = { "sources.default" },
}
