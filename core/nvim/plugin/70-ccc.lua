require("ccc").setup({
  higlighter = {
    auto_enable = true,
    lsp = true,
  },
})

vim.keymap.set("n", "<leader>uc", ":CccHighlighterToggle<cr>", { desc = "Toggle color higlighter" })
