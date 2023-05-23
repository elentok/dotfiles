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

local ok, git_conflict = pcall(require, "git-conflict")
if ok then
  git_conflict.setup()
end

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
vim.keymap.set("n", "<leader>gl", telescope_git_last_commit_files)
