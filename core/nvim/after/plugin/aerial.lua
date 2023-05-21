local ok, aerial = pcall(require, "aerial")
if not ok then
  return
end

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
    vim.keymap.set("n", "<Leader>ta", "<cmd>AerialToggle!<cr>", { buffer = bufnr })
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>", { buffer = bufnr })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>", { buffer = bufnr })
  end,
  nav = {
    keymaps = {
      ["?"] = "actions.help",
      ["q"] = "actions.close",
    },
  },
})

vim.cmd([[hi link AerialLine DiffAdd]])
