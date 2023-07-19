local aerial = require("aerial")

aerial.setup({
  backends = {
    ["_"] = { "lsp", "treesitter" },
    markdown = { "markdown" },
  },
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Constant",
  },
  on_attach = function(bufnr)
    vim.keymap.set("n", "<space>ta", "<cmd>AerialToggle left<cr>", { buffer = bufnr })
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>", { buffer = bufnr })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>", { buffer = bufnr })
    vim.keymap.set(
      "n",
      "<space>oa",
      "<cmd>AerialNavOpen<cr>",
      { buffer = bufnr, desc = "Open Aerial navigation" }
    )
  end,
  nav = {
    keymaps = {
      ["?"] = "actions.help",
      ["q"] = "actions.close",
    },
  },
})

vim.cmd([[hi link AerialLine DiffAdd]])
