local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local term = require("elentok.lib.terminal")
local git = require("elentok.lib.git")

vim.api.nvim_create_user_command("GG", function(opts)
  git.run(opts.fargs)
end, { nargs = "+" })

vim.api.nvim_create_user_command("Gap", function(opts)
  local args = vim.list_extend({ "add", "-p" }, opts.fargs)
  git.run(args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Gps", ":GG push", {})
vim.api.nvim_create_user_command("Gpl", ":GG pull --rebase", {})
vim.api.nvim_create_user_command("Gsync", ":GG sync", {})

-- local git_conflict = require("git-conflict")
-- git_conflict.setup({})
--
-- vim.keymap.set("n", "<space>gc", "<cmd>GitConflictListQf<cr>", { desc = "Git list conflicts" })
-- vim.keymap.set("n", "<space>co", "<Plug>(git-conflict-ours)")
-- vim.keymap.set("n", "<space>ct", "<Plug>(git-conflict-theirs)")
-- vim.keymap.set("n", "<space>cb", "<Plug>(git-conflict-both)")
-- vim.keymap.set("n", "<space>c0", "<Plug>(git-conflict-none)")
-- vim.keymap.set("n", "[m", "<Plug>(git-conflict-prev-conflict)")
-- vim.keymap.set("n", "]m", "<Plug>(git-conflict-next-conflict)")

vim.keymap.set({ "n" }, "<space>mw", ":noa wqa<cr>")
vim.keymap.set({ "n" }, "<space>mL", "ggVG:diffget LOCAL<cr>")
vim.keymap.set({ "n" }, "<space>mR", "ggVG:diffget REMOTE<cr>")
vim.keymap.set({ "n", "v" }, "<space>ml", ":diffget LOCAL<cr>")
vim.keymap.set({ "n", "v" }, "<space>mr", ":diffget REMOTE<cr>")

local function telescope_git_last_commit_files()
  pickers
    .new({}, {
      finder = finders.new_oneshot_job({
        "git",
        "diff-tree",
        "--no-commit-id",
        "--name-only",
        "-r",
        "HEAD",
      }, {}),
      previewer = conf.file_previewer({}),
    })
    :find()
end

vim.api.nvim_create_user_command("Glast", telescope_git_last_commit_files, {})
vim.keymap.set(
  "n",
  "<space>jl",
  telescope_git_last_commit_files,
  { desc = "Jump to files in last commit" }
)
vim.keymap.set("n", "<space>gw", "<cmd>Gwrite<cr>", { desc = "Git write" })
vim.keymap.set("n", "<space>gg", "<cmd>G<cr><c-w>H", { desc = "Git status" })
vim.keymap.set("n", "<space>gb", "<cmd>G blame<cr>", { desc = "Git blame" })
vim.keymap.set("n", "<space>gl", "<cmd>G log HEAD...master<cr>", { desc = "Git log" })

local function git_history()
  local filename = vim.fn.expand("%")
  if filename == "" or filename:match("^fugitive:") then
    term.run({ "tig" })
  else
    term.run({ "tig", "--follow", filename })
  end
end

vim.keymap.set("n", "<space>gh", git_history, { desc = "Git file history" })
vim.keymap.set("n", "<space>gt", function()
  term.run({ "tig" })
end, { desc = "Tig" })

vim.keymap.set("n", "<space>gd", function()
  term.run({ "git", "diff", vim.fn.expand("%") })
end, { desc = "Git diff current file" })
