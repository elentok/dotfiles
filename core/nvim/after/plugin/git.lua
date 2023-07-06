local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

vim.cmd([[
  command! -nargs=+ GG lua require('elentok/util').ishell('git <args>')
  command! Gps GG push
  command! Gpl GG pull --rebase
  command! Gsync GG sync
  command! -nargs=* Gap lua require('elentok/util').ishell('git add -p <args>', { large = true })
]])

local git_conflict = require("git-conflict")
git_conflict.setup()

vim.keymap.set("n", "<space>gc", ":GitConflictListQf<cr>")
vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
vim.keymap.set("n", "ct", "<Plug>(git-conflict-theirs)")
vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)")
vim.keymap.set("n", "[m", "<Plug>(git-conflict-prev-conflict)")
vim.keymap.set("n", "]m", "<Plug>(git-conflict-next-conflict)")

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
        }),
        previewer = conf.file_previewer({}),
      })
      :find()
end

vim.api.nvim_create_user_command("Glast", telescope_git_last_commit_files, {})
vim.keymap.set("n", "<space>gl", telescope_git_last_commit_files)
vim.keymap.set("n", "<space>gg", ":G<cr>")
vim.keymap.set("n", "<space>gb", ":G blame<cr>")
