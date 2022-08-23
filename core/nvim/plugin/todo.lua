local unchecked = "%[ %]"
local checked = "%[x%]"

local function todo_toggle_done()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, unchecked)
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  end
  vim.fn.setline(".", line)
end

local function todo_next_state()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, unchecked)
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, "[inprogress]")
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", "[waiting]")
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", checked)
  end
  vim.fn.setline(".", line)
end

local function todo_prev_state()
  local line = vim.fn.getline(".")
  if line:match(checked) then
    line = line:gsub(checked, "[waiting]")
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", unchecked)
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", "[inprogress]")
  end
  vim.fn.setline(".", line)
end

vim.keymap.set("n", "<Leader>td", todo_toggle_done)
vim.keymap.set("n", "<Leader>tp", todo_prev_state)
vim.keymap.set("n", "<Leader>tn", todo_next_state)

vim.keymap.set("n", "[t", todo_prev_state)
vim.keymap.set("n", "]t", todo_next_state)
