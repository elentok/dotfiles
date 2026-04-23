local loaded = false

local function load_blink()
  if loaded then return end
  loaded = true

  local sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {},
  }

  vim.cmd.packadd("blink.cmp")

  require("blink.cmp").setup({
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
  })
end

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = load_blink,
})
