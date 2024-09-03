local unchecked = "%[ %]"
local checked = "%[x%]"

local DONE_COLOR = "#6C7A96"

---@class StatusOptions
---@field name string
---@field text? string
---@field icon? string
---@field hl? table<string, any>

---@class Status
---@field name string
---@field title string
---@field char string
---@field index integer
---@field icon? string
---@field hl? table<string, any>

---@class SetupOptions
---@field statuses? Status[]
--
---@class Config
---@field statuses Status[]

local default_statuses = {
  {
    name = "todo",
    title = "Todo",
    char = " ",
    icon = "󱓼",
  },
  {
    name = "in_progress",
    title = "In progress",
    char = "/",
    icon = "󰪠",
    hl = { fg = "#EBCB8B" },
  },
  {
    name = "waiting",
    title = "Waiting",
    char = "w",
    icon = "󰏦",
    hl = { fg = "#C27D00" },
  },
  {
    name = "code_review",
    title = "Code Review",
    char = "r",
    icon = "",
    hl = { fg = "#9369DB" },
  },
  {
    name = "done",
    title = "Done",
    char = "x",
    hl = { fg = DONE_COLOR },
    icon = "󰄬",
  },
}

---@param options StatusOptions[]
---@return Status[]
local function build_statuses(options)
  ---@type Status[]
  local statuses = {}

  for index, status_options in ipairs(options) do
    table.insert(statuses, vim.tbl_extend("force", { index = index }, status_options))
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

  vim.fn.matchadd(group, "\\[" .. status.char .. "\\].*$")
  vim.api.nvim_set_hl(0, group, status.hl)
end

local statuses_with_icons = {}
for _, status in ipairs(config.statuses) do
  table.insert(statuses_with_icons, status.icon .. " " .. status.title)
end

local function replace_in_current_line(pattern, replacement)
  local line = vim.api.nvim_get_current_line()
  put(line)
  local new_line = line:gsub(pattern, replacement)
  put(new_line)
  vim.api.nvim_set_current_line(new_line)
end

local function set_task_status()
  require("fzf-lua").fzf_exec(statuses_with_icons, {
    prompt = "Status> ",
    winopts = {
      width = 20,
      height = #statuses_with_icons + 2,
    },
    actions = {
      ["default"] = function(selected)
        local status_line = selected[1]
        local index = vim.fn.index(statuses_with_icons, status_line)
        local status = config.statuses[index + 1]
        put(status)
        -- TODO: fix this
        replace_in_current_line("\\[?\\]", "[" .. status.char .. "]")
      end,
    },
  })
end

-- ---@param status Status
-- local function add_icon(status)
--   -- local text = status.text or status.name
--   -- vim.fn.matchadd("Conceal", "\\[" .. text .. "\\]", 20, -1, { conceal = status.icon })
-- end

local function setup_buffer()
  for _, status in ipairs(config.statuses) do
    if status.hl ~= nil then
      add_highlight(status)
    end
    -- if status.icon ~= nil then
    --   add_icon(status)
    -- end
  end

  vim.fn.matchadd("TodoContext", "@[^ ]*")
  vim.fn.matchadd("TodoImportant", " !.*$")

  vim.api.nvim_set_hl(0, "TodoContext", { fg = "#88c0d0", italic = true })
  vim.api.nvim_set_hl(0, "TodoImportant", { fg = "#d57780" })

  vim.keymap.set("n", "<cr>s", set_task_status, { buffer = true })

  -- vim.wo.foldmethod = "indent"
end

local group_id = vim.api.nvim_create_augroup("Elentok_Markdown", {})

vim.api.nvim_create_autocmd(
  { "BufRead", "WinNew" },
  { pattern = "*.md", group = group_id, callback = setup_buffer }
)

-- vim.keymap.set("n", "<leader>jt", function()
--   require("telescope.builtin").grep_string({ search = "[ ]", search_dirs = { vim.fn.expand("%") } })
-- end, { desc = "Jump to open task" })

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
    line = line:gsub(unchecked, "[/]")
  elseif line:match("%[/%]") then
    line = line:gsub("%[/%]", "[?]")
  elseif line:match("%[%?%]") then
    line = line:gsub("%[%?%]", checked)
  end
  if line ~= oldline then
    vim.fn.setline(".", line)
  end
end

local function todo_prev_state()
  local oldline = vim.fn.getline(".")
  local line = oldline
  if line:match(checked) then
    line = line:gsub(checked, "[?]")
  elseif line:match(unchecked) then
    line = line:gsub(unchecked, checked)
  elseif line:match("%[/%]") then
    line = line:gsub("%[/%]", unchecked)
  elseif line:match("%[%?%]") then
    line = line:gsub("%[%?%]", "[/]")
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
