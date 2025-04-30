local map = vim.keymap.set

map({ "i" }, "jk", "<esc>")

-- Map <leader>n and <leader>p to [ and ] to make it easier to use unimpaired
-- mappings without "[" and "]"
map({ "n", "v" }, "<leader>p", "[", { remap = true })
map({ "n", "v" }, "<leader>n", "]", { remap = true })

map("n", "<leader>uv", function()
  local virtual_lines = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({
    virtual_lines = virtual_lines,
  })
  if virtual_lines then
    vim.notify("Virtual lines enabled")
  else
    vim.notify("Virtual lines disabled")
  end
end, { desc = "Toggle virtual_lines diagnostics" })

map("n", "<leader>of", "<cmd>!dotf-open %<cr>", { desc = "Open current file" })
map("n", "gw", function() vim.diagnostic.open_float() end, { desc = "Show diagnostic" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code actions" })
