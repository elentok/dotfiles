local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local gitlinker = require("gitlinker")
local terminal = require("elentok.lib.terminal")

gitlinker.setup({ mappings = nil })
vim.keymap.set("n", "<space>gy", function()
  gitlinker.get_buf_range_url("n")
end, { silent = true, desc = "Git yank URL" })
vim.keymap.set("v", "<space>gy", function()
  gitlinker.get_buf_range_url("v")
end, { silent = true, desc = "Git yank URL" })

vim.cmd([[
  command! -nargs=+ GG lua require('elentok/util').ishell('git <args>')
  command! Gps GG push
  command! Gpl GG pull --rebase
  command! Gsync GG sync
  command! -nargs=* Gap lua require('elentok/util').ishell('git add -p <args>', { large = true })
]])

local git_conflict = require("git-conflict")
git_conflict.setup({})

vim.keymap.set("n", "<space>gc", "<cmd>GitConflictListQf<cr>", { desc = "Git list conflicts" })
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
vim.keymap.set("n", "<space>gg", "<cmd>G<cr><c-w>L", { desc = "Git status" })
vim.keymap.set("n", "<space>gb", "<cmd>G blame<cr>", { desc = "Git blame" })

local function git_history()
  local filename = vim.fn.expand("%")
  if filename == "" or filename:match("^fugitive:") then
    terminal.run({ "tig" })
  else
    terminal.run({ "tig", "--follow", filename })
  end
end

vim.keymap.set("n", "<space>gh", git_history, { desc = "Git file history" })
vim.keymap.set("n", "<space>gt", function()
  terminal.run({ "tig" })
end, { desc = "Tig" })

vim.keymap.set("n", "<space>gd", function()
  terminal.run({ "git", "diff", vim.fn.expand("%") })
end, { desc = "Git diff current file" })
