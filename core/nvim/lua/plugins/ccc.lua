return {
  "uga-rosa/ccc.nvim",
  event = { "LazyFile" },
  opts = {
    higlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  keys = {
    {
      "<leader>uc",
      ":CccHighlighterToggle<cr>",
      desc = "Toggle color higlighter",
    },
  },
}
