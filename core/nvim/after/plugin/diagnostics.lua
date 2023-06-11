vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  float = {
    border = "rounded",
  },
})

vim.keymap.set("n", "gl", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>dd", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>dq", vim.diagnostic.setqflist)

-- Toggle diagnostics:
local diagnostic_visible = true
local function toggle_diagnostic()
  if diagnostic_visible then
    vim.diagnostic.hide()
    diagnostic_visible = false
    print("Diagnostics: hidden")
  else
    vim.diagnostic.show()
    diagnostic_visible = true
    print("Diagnostics: visible")
  end
end

vim.keymap.set("n", "<Leader>te", toggle_diagnostic)
