-- vim.keymap.set("n", "<leader>gc", "<cmd>GitConflictListQf<cr>", { desc = "Git list conflicts" })
vim.keymap.set("n", "<leader>g2", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "<leader>g3", "<Plug>(git-conflict-theirs)")
-- vim.keymap.set("n", "<leader>cb", "<Plug>(git-conflict-both)")
-- vim.keymap.set("n", "<leader>c0", "<Plug>(git-conflict-none)")
-- vim.keymap.set("n", "[m", "<Plug>(git-conflict-prev-conflict)")
-- vim.keymap.set("n", "]m", "<Plug>(git-conflict-next-conflict)")

local function next_conflict_marker()
  vim.fn.search("\\(<<<<<<<\\|=======\\|>>>>>>>\\)")
end

local function prev_conflict_marker()
  vim.fn.search("\\(<<<<<<<\\|=======\\|>>>>>>>\\)", "b")
end

vim.keymap.set({ "n", "v" }, "[m", prev_conflict_marker)
vim.keymap.set({ "n", "v" }, "]m", next_conflict_marker)
vim.keymap.set({ "n" }, "<leader>mw", ":noa wqa<cr>")
vim.keymap.set({ "n" }, "<leader>mL", "ggVG:diffget LOCAL<cr>")
vim.keymap.set({ "n" }, "<leader>mR", "ggVG:diffget REMOTE<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ml", ":diffget LOCAL<cr>")
vim.keymap.set({ "n", "v" }, "<leader>mr", ":diffget REMOTE<cr>")
