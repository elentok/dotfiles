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

-- vim.keymap.set("n", "<space>gc", "<cmd>GitConflictListQf<cr>", { desc = "Git list conflicts" })
vim.keymap.set("n", "<space>g2", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "<space>g3", "<Plug>(git-conflict-theirs)")
-- vim.keymap.set("n", "<space>cb", "<Plug>(git-conflict-both)")
-- vim.keymap.set("n", "<space>c0", "<Plug>(git-conflict-none)")
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

vim.keymap.set("n", "<space>gps", "<cmd>Gps<cr>", { desc = "Git push" })
vim.keymap.set("n", "<space>gpl", "<cmd>Gpl<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<space>gpm", "<cmd>G psme<cr>", { desc = "Git push me" })
vim.keymap.set("n", "<space>gs", "<cmd>Gsync<cr>", { desc = "Git sync" })

-- vim.keymap.set("n", "<space>g2", "<cmd>diffget //2<cr>", { desc = "Git resolve conflict from //2" })
-- vim.keymap.set("n", "<space>g3", "<cmd>diffget //3<cr>", { desc = "Git resolve conflict from //3" })

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
