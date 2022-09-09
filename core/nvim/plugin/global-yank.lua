-- When yanking text copy it to every possible clipboard

local function global_yank()
  local e = vim.v.event
  local contents = vim.fn.join(e.regcontents, "\n")
  if e.regtype == "V" then
    contents = contents .. "\n"
  end

  vim.fn.system("dotf-clipboard copy", contents)
end

local group_id = vim.api.nvim_create_augroup("Elentok_GlobalYank", {})
vim.api.nvim_create_autocmd(
  { "TextYankPost" },
  { pattern = "*", callback = global_yank, group = group_id }
)
