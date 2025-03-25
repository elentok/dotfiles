local function git_url(command)
  local line = vim.fn.line(".")
  vim.fn.jobstart(
    "git " .. command .. " -b=main -r=upstream -l=" .. line .. " " .. vim.fn.shellescape(vim.fn.expand("%"))
  )
end

vim.keymap.set("n", "<leader>gy", function()
  git_url("yank")
end, { desc = "Git yank URL" })
vim.keymap.set("n", "<leader>gY", "<cmd>!git yank -b %<cr>", { desc = "Git yank URL" })
vim.keymap.set("n", "<leader>go", function()
  git_url("open")
end, { desc = "Git open URL" })
vim.keymap.set("n", "<leader>gO", "<cmd>!git open -b %<cr>", { desc = "Git open URL" })
