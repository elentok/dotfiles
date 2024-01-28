local unchecked = "%[ %]"
local checked = "%[x%]"

local DONE_COLOR = "#6C7A96"

---@class StatusOptions
---@field name string
---@field text? string
---@field conceal? string
---@field hl? table<string, any>

---@class Status
---@field name string
---@field text string
---@field index integer
---@field conceal? string
---@field hl? table<string, any>

---@class SetupOptions
---@field statuses? Status[]
--
---@class Config
---@field statuses Status[]

local default_statuses = {
  {
    name = "open",
    text = " ",
    conceal = "☐",
  },
  {
    name = "inprogress",
    -- hl = { bg = "#EBCB8B", fg = "#000000" },
    hl = { fg = "#EBCB8B" },
    -- conceal = "😎",
    conceal = "◐",
  },
  {
    name = "waiting",
    hl = { fg = "#C27D00" },
    -- conceal = "⌛",
    conceal = "⌚",
  },
  {
    name = "codereview",
    hl = { fg = "#9369DB" },
    conceal = "📖",
  },
  {
    name = "done",
    text = "x",
    hl = { fg = DONE_COLOR },
    conceal = "✓",
  },
}

---@param options StatusOptions[]
---@return Status[]
local function build_statuses(options)
  ---@type Status[]
  local statuses = {}

  for index, status_options in ipairs(options) do
    table.insert(statuses, {
      name = status_options.name,
      text = status_options.text or status_options.name,
      hl = status_options.hl,
      conceal = status_options.conceal,
      index = index,
    })
  end

  return statuses
end

---@type Config
local config = {
  statuses = build_statuses(default_statuses),
}

---@param status Status
local function add_highlight(status)
  local capitalized_name = status.name:sub(1, 1):upper() .. status.name:sub(2)
  local group = "Todo" .. capitalized_name
  local text = status.text or status.name

  vim.fn.matchadd(group, "\\[" .. text .. "\\].*$")
  vim.api.nvim_set_hl(0, group, status.hl)
end

---@param status Status
local function add_conceal(status)
  local text = status.text or status.name
  vim.fn.matchadd("Conceal", "\\[" .. text .. "\\]", 20, -1, { conceal = status.conceal })
end

local function setup_buffer()
  for _, status in ipairs(config.statuses) do
    if status.hl ~= nil then
      add_highlight(status)
    end
    if status.conceal ~= nil then
      add_conceal(status)
    end
  end

  vim.fn.matchadd("TodoContext", "@[^ ]*")
  vim.fn.matchadd("TodoImportant", " !.*$")

  vim.api.nvim_set_hl(0, "TodoContext", { fg = "#88c0d0", italic = true })
  vim.api.nvim_set_hl(0, "TodoImportant", { fg = "#d57780" })

  -- vim.wo.foldmethod = "indent"
end

local group_id = vim.api.nvim_create_augroup("Elentok_Markdown", {})

vim.api.nvim_create_autocmd(
  { "BufRead", "WinNew" },
  { pattern = "*.md", group = group_id, callback = setup_buffer }
)

local has_builtin, builtin = pcall(require, "telescope.builtin")
if has_builtin then
  vim.keymap.set("n", "<leader>jt", function()
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

---@return { status: Status, index: integer } | nil
-- local function todo_get_status(line)
--   for index, status in ipairs()
-- end

local function todo_toggle_done_visible()
  local done_fg_color = vim.api.nvim_get_hl_by_name("TodoDone", true).foreground
  local normal_bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background

  if done_fg_color == normal_bg_color then
    vim.api.nvim_set_hl(0, "TodoDone", { fg = DONE_COLOR })
  else
    vim.api.nvim_set_hl(0, "TodoDone", { fg = normal_bg_color })
  end
end

vim.keymap.set("n", "<leader>td", todo_toggle_done, { desc = "Todo - toggle done" })
vim.keymap.set("n", "<leader>tv", todo_toggle_done_visible, { desc = "Todo - toggle done visible" })

vim.keymap.set("n", "[t", todo_prev_state, { desc = "Todo - prev state" })
vim.keymap.set("n", "]t", todo_next_state, { desc = "Todo - next state" })
