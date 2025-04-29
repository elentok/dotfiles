local M = {}

local function find_buffer_windows()
  local current_buf = vim.api.nvim_get_current_buf()

  local windows = vim.api.nvim_list_wins()
  local buffer_windows = {}
  for _, win in ipairs(windows) do
    local win_buf = vim.api.nvim_win_get_buf(win)

    if win_buf == current_buf then
      table.insert(buffer_windows, win)
    end
  end

  return buffer_windows
end

local function find_buffer_win_cursors()
  local cursors = {}

  local buffer_windows = find_buffer_windows()
  for _, win in ipairs(buffer_windows) do
    cursors[win] = vim.api.nvim_win_get_cursor(win)
  end

  return cursors
end

local win_cursor_cache_by_buf = {}

function M.save_buf_cursors()
  local cursors = find_buffer_win_cursors()
  win_cursor_cache_by_buf[vim.api.nvim_get_current_buf()] = cursors
end

function M.restore_buf_cursors()
  local current_buf = vim.api.nvim_get_current_buf()

  for win, cursor in pairs(win_cursor_cache_by_buf[current_buf] or {}) do
    cursor[1] = math.min(cursor[1], vim.api.nvim_buf_line_count(0))
    vim.api.nvim_win_set_cursor(win, cursor)
  end
end

return M
