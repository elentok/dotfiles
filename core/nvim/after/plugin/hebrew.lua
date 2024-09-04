local function toggleHebrew()
  if vim.wo.rightleft then
    vim.wo.rightleft = false
    vim.bo.keymap = nil
  else
    vim.wo.rightleft = true
    vim.bo.keymap = "hebrew"
  end

  vim.cmd("stopinsert")
  vim.fn.timer_start(0, function()
    vim.cmd("startinsert")
  end)
end

vim.keymap.set({ "n", "i" }, "<c-\\>", toggleHebrew)
