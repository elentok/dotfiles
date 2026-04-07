require("grug-far").setup({})

vim.keymap.set("n", "<leader>fr", "<Cmd>GrugFar<cr>", { desc = "Find and replace" })
vim.keymap.set(
  "v",
  "<leader>fr",
  function() require("grug-far").with_visual_selection() end,
  { desc = "Find and replace (selection)" }
)
vim.keymap.set(
  "n",
  "<leader>wfr",
  function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
  { desc = "Find and replace (selection)" }
)
