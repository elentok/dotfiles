local function buf_git_root()
  return vim.fn.systemlist("git-root '" .. vim.fn.expand("%") .. "'")[1]
end

local function cd_to_git_root()
  local root = buf_git_root()
  vim.cmd("cd " .. root)
  print("Changed directory to: " .. root)
end

vim.keymap.set("n", "<Leader>cg", cd_to_git_root, { desc = "CD to git root" })

vim.keymap.set(
  "n",
  "<leader>cd",
  ':cd <C-R>=expand("%:p:h")<cr>',
  { desc = "CD to directory of current file" }
)
