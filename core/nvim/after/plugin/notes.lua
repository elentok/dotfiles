-- Function to get the date of the most recent Sunday
---@return integer
local function get_sunday_of_current_week()
  local current_date = os.date("*t")
  local diff_to_sunday = current_date.wday - 1
  local sunday_time = os.time() - (diff_to_sunday * 24 * 60 * 60)
  return sunday_time

  -- Return the date of the most recent Sunday
  -- return os.date("%Y-%m-%d", sunday_time)
end

---@param root string | nil
---@return string
local function get_weekly_note_filename(root)
  if root == nil then
    root = vim.uv.cwd()
  end
  local sunday = get_sunday_of_current_week()
  local week = os.date("%V", sunday) + 1
  local year = os.date("%Y", sunday)

  local basename = os.date("%Y-week" .. week .. "-%b-%d.md", sunday)
  ---@cast basename string
  basename = basename:lower()
  local dir = string.format("%s/weekly/%d", root, year)
  local filename = string.format("%s/%s", dir, basename)

  if not vim.fn.filereadable(filename) then
    vim.fn.mkdir(dir, "p")
    local title = os.date("# Week %V, %Y (%B %d)", sunday)
    vim.fn.writefile({ title }, filename)
  end

  return filename
end

local function jump_to_weekly()
  local note = get_weekly_note_filename()
  -- local note = vim.fn.system("weekly-note.ts")
  if note == "" then
    vim.notify("No weekly directory", vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit " .. note)
  vim.cmd("e")
end
vim.keymap.set("n", "<leader>jw", jump_to_weekly, { desc = "Jump to weekly note" })
