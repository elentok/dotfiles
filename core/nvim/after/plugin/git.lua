local term = require("elentok.lib.terminal")
local git = require("elentok.lib.git")
local ui = require("elentok.lib.ui")

vim.api.nvim_create_user_command("GG", function(opts)
  git.run(opts.fargs)
end, { nargs = "+" })

vim.api.nvim_create_user_command("Gap", function(opts)
  local args = vim.list_extend({ "add", "-p" }, opts.fargs)
  git.run(args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Gps", ":GG push", {})
vim.api.nvim_create_user_command("Gpl", ":GG pull --rebase", {})
vim.api.nvim_create_user_command("Gsync", ":GG autosync", {})

local function git_reset_file_changes()
  if ui.confirm("Reset changes in current file?") then
    vim.cmd("silent edit!")
    vim.fn.system("git checkout -- " .. vim.fn.shellescape(vim.fn.expand("%")))
    vim.cmd("silent edit")
  end
end

vim.keymap.set("n", "<leader>ga", "<cmd>Gap<cr>", { desc = "Git add (patch)" })
vim.keymap.set("n", "<leader>gw", "<cmd>w<cr>!git add %<cr>", { desc = "Write + Stage" })
vim.keymap.set("n", "<leader>gr", git_reset_file_changes, { desc = "Reset git changes" })

vim.keymap.set("n", "<leader>gps", "<cmd>Gps<cr>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gpl", "<cmd>Gpl<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gpm", "<cmd>GG psme<cr>", { desc = "Git push me" })
vim.keymap.set("n", "<leader>gs", "<cmd>Gsync<cr>", { desc = "Git autosync" })

-- local function git_history()
--   local filename = vim.fn.expand("%")
--   if filename == "" or filename:match("^fugitive:") then
--     term.run({ "tig" })
--   else
--     term.run({ "tig", "--follow", filename })
--   end
-- end

-- vim.keymap.set("n", "<leader>gh", git_history, { desc = "Git file history" })
vim.keymap.set("n", "<leader>gt", function()
  term.run({ "tig" })
end, { desc = "Tig" })

vim.keymap.set("n", "<leader>gd", function()
  term.run({ "git", "diff", vim.fn.expand("%") })
end, { desc = "Git diff current file" })
