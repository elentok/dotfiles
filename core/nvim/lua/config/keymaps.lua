local map = vim.keymap.set

map({ "i" }, "jk", "<esc>")

map({ "n" }, "U", "<c-r>")

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

map("n", "<leader>ol", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
map("n", "<leader>of", "<cmd>!dotf-open %<cr>", { desc = "Open current file" })
map("n", "gw", function() vim.diagnostic.open_float() end, { desc = "Show diagnostic" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "Code actions" })
map("n", "q", function() print("macros are disabled") end)

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function(args)
    vim.keymap.set("n", "q", ":q<cr>", { desc = "Close command window", buffer = args.buf })
  end,
})

vim.keymap.set("i", "<D-h>", "<C-h>", { remap = true })
vim.keymap.set("i", "<D-j>", "<C-j>", { remap = true })
vim.keymap.set("i", "<D-k>", "<C-k>", { remap = true })
vim.keymap.set("i", "<D-l>", "<C-l>", { remap = true })
