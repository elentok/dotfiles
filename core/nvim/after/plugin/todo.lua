local unchecked = "%[ %]"
local checked = "%[x%]"

local DONE_COLOR = "#6C7A96"

local function setup()
  vim.fn.matchadd("TodoInprogress", "\\[inprogress\\].*$")
  vim.fn.matchadd("TodoWaiting", "\\[waiting\\].*$")
  vim.fn.matchadd("TodoDone", "\\[x\\].*$")
  vim.fn.matchadd("TodoContext", "@[^ ]*")
  vim.fn.matchadd("TodoImportant", " !.*$")

  vim.api.nvim_set_hl(0, "TodoInprogress", { bg = "#EBCB8B", fg = "#000000" })
  vim.api.nvim_set_hl(0, "TodoWaiting", { fg = "#EBCB8B" })
  vim.api.nvim_set_hl(0, "TodoDone", { fg = DONE_COLOR })
  vim.api.nvim_set_hl(0, "TodoContext", { fg = "#88c0d0", italic = true })
  vim.api.nvim_set_hl(0, "TodoImportant", { fg = "#d57780" })

  vim.wo.foldmethod = "indent"
end

local group_id = vim.api.nvim_create_augroup("Elentok_Markdown", {})

vim.api.nvim_create_autocmd(
  { "BufRead", "WinNew" },
  { pattern = "*.md", group = group_id, callback = setup }
)

local has_builtin, builtin = pcall(require, "telescope.builtin")
if has_builtin then
  vim.keymap.set("n", "<Leader>gt", function()
    builtin.grep_string({ search = "[ ]", search_dirs = { vim.fn.expand("%") } })
  end)
end

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

local function todo_toggle_done_visible()
  local done_fg_color = vim.api.nvim_get_hl_by_name("TodoDone", true).foreground
  local normal_bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background

  if done_fg_color == normal_bg_color then
    vim.api.nvim_set_hl(0, "TodoDone", { fg = DONE_COLOR })
  else
    vim.api.nvim_set_hl(0, "TodoDone", { fg = normal_bg_color })
  end
end

vim.keymap.set("n", "<Leader>td", todo_toggle_done)
vim.keymap.set("n", "<Leader>tp", todo_prev_state)
vim.keymap.set("n", "<Leader>tn", todo_next_state)
vim.keymap.set("n", "<Leader>tf", todo_toggle_done_visible)

vim.keymap.set("n", "[t", todo_prev_state)
vim.keymap.set("n", "]t", todo_next_state)