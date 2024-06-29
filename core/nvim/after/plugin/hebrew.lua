local function toggleHebrew()
  if vim.wo.rightleft then
    vim.wo.rightleft = false
    vim.bo.keymap = nil
  else
    vim.wo.rightleft = true
    vim.bo.keymap = "hebrew"
  end
end

vim.keymap.set({ "n", "i" }, "<c-\\>", toggleHebrew)
