local function jump_to_weekly()
  local note = vim.fn.system("weekly-note.ts")
  vim.cmd("edit " .. note)
  vim.cmd("e")
end
vim.keymap.set("n", "<leader>jw", jump_to_weekly, { desc = "Jump to weekly note" })
