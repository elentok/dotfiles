local ok, aerial = pcall(require, "aerial")
if not ok then
  return
end

aerial.setup({
  backends = {
    ["_"] = { "lsp", "treesitter" },
    markdown = { "markdown" },
  },
  on_attach = function(bufnr)
    vim.keymap.set("n", "<Leader>ta", "<cmd>AerialToggle!<cr>", { buffer = bufnr })
    vim.keymap.set("n", "[[", "<cmd>AerialPrev<cr>", { buffer = bufnr })
    vim.keymap.set("n", "]]", "<cmd>AerialNext<cr>", { buffer = bufnr })
  end,
})

vim.cmd([[hi link AerialLine DiffAdd]])
