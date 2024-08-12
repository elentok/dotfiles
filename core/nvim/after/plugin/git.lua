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

local function git_reset_file_changes()
  if ui.confirm("Reset changes in current file?") then
    vim.cmd("silent edit!")
    vim.fn.system("git checkout -- " .. vim.fn.shellescape(vim.fn.expand("%")))
    vim.cmd("silent edit")
  end
end

vim.keymap.set({ "n" }, "<leader>mw", ":noa wqa<cr>")
vim.keymap.set({ "n" }, "<leader>mL", "ggVG:diffget LOCAL<cr>")
vim.keymap.set({ "n" }, "<leader>mR", "ggVG:diffget REMOTE<cr>")
vim.keymap.set({ "n", "v" }, "<leader>ml", ":diffget LOCAL<cr>")
vim.keymap.set({ "n", "v" }, "<leader>mr", ":diffget REMOTE<cr>")
vim.keymap.set("n", "<leader>ga", "<cmd>Gap<cr>", { desc = "Git add (patch)" })
vim.keymap.set("n", "<leader>gw", "<cmd>w<cr>!git add %<cr>", { desc = "Write + Stage" })
vim.keymap.set("n", "<leader>gr", git_reset_file_changes, { desc = "Reset git changes" })
-- vim.keymap.set("n", "<leader>gg", "<cmd>G<cr><c-w>H", { desc = "Git status" })
-- vim.keymap.set("n", "<leader>gba", "<cmd>G blame<cr>", { desc = "Git blame" })
-- vim.keymap.set("n", "<leader>gl", "<cmd>G log HEAD...master<cr>", { desc = "Git log" })

local function gitUrl(command)
  local line = vim.fn.line(".")
  vim.fn.jobstart(
    "git "
      .. command
      .. " -b=main -r=upstream -l="
      .. line
      .. " "
      .. vim.fn.shellescape(vim.fn.expand("%"))
  )
end

vim.keymap.set("n", "<leader>gy", function()
  gitUrl("yank")
end, { desc = "Git yank URL" })
vim.keymap.set("n", "<leader>gY", "<cmd>!git yank -b %<cr>", { desc = "Git yank URL" })
vim.keymap.set("n", "<leader>go", function()
  gitUrl("open")
end, { desc = "Git open URL" })
vim.keymap.set("n", "<leader>gO", "<cmd>!git open -b %<cr>", { desc = "Git open URL" })

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
