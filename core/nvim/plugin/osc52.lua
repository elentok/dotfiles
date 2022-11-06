-- Only use OSC52 when in an SSH  session
if vim.env.SSH_TTY == nil then
  return
end

local ok, osc52 = pcall(require, "osc52")
if not ok then
  return
end

local function copy(lines, _)
  osc52.copy(table.concat(lines, "\n"))
end

local function global_yank()
  local e = vim.v.event
  copy(e.regcontents)
end

local group_id = vim.api.nvim_create_augroup("Elentok_GlobalYank", {})
vim.api.nvim_create_autocmd(
  { "TextYankPost" },
  { pattern = "*", callback = global_yank, group = group_id }
)
