local unchecked = "%[ %]"
local checked = "%[x%]"

local DONE_COLOR = "#6C7A96"

local config = {
  statuses = {
    inprogress = {
      hl = { bg = "#EBCB8B", fg = "#000000" },
    },
    waiting = {
      hl = { fg = "#EBCB8B" },
    },
    codereview = {
      hl = { fg = "#9369DB" },
    },
    done = {
      text = "x",
      hl = { fg = DONE_COLOR },
    },
  },
}

local function setup()
  for status_name, status_opts in pairs(config.statuses) do
    local capitalized_name = status_name:sub(1, 1):upper() .. status_name:sub(2)
    local group = "Todo" .. capitalized_name
    local text = status_opts.text or status_name

    vim.fn.matchadd(group, "\\[" .. text .. "\\].*$")
    vim.api.nvim_set_hl(0, group, status_opts.hl)
  end

  vim.fn.matchadd("TodoContext", "@[^ ]*")
  vim.fn.matchadd("TodoImportant", " !.*$")

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
  vim.keymap.set("n", "<space>jt", function()
    builtin.grep_string({ search = "[ ]", search_dirs = { vim.fn.expand("%") } })
  end, { desc = "Jump to open task" })
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
  local oldline = vim.fn.getline(".")
  local line = oldline
  if line:match(checked) then
    line = line:gsub(checked, unchecked)
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, "[inprogress]")
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", "[waiting]")
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", checked)
  end
  if line ~= oldline then
    vim.fn.setline(".", line)
  end
end

local function todo_prev_state()
  local oldline = vim.fn.getline(".")
  local line = oldline
  if line:match(checked) then
    line = line:gsub(checked, "[waiting]")
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  elseif line:match("%[inprogress%]") then
    line = line:gsub("%[inprogress%]", unchecked)
  elseif line:match("%[waiting%]") then
    line = line:gsub("%[waiting%]", "[inprogress]")
  end
  if line ~= oldline then
    vim.fn.setline(".", line)
  end
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

vim.keymap.set("n", "<space>td", todo_toggle_done, { desc = "Todo - toggle done" })
vim.keymap.set("n", "<space>tf", todo_toggle_done_visible, { desc = "Todo - toggle done visible" })

vim.keymap.set("n", "[t", todo_prev_state, { desc = "Todo - prev state" })
vim.keymap.set("n", "]t", todo_next_state, { desc = "Todo - next state" })
