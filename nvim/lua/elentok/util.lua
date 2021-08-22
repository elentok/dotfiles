local api = vim.api

local log_enabled = false

local M = {}

M.set_log = function(enabled) log_enabled = enabled end

M.log = function(message) if log_enabled then print(message) end end

M.safe_require = function(name)
  local status, module = pcall(require, name)
  if (status) then
    return module
  else
    print(string.format('WARNING: error loading lua module "%s"', name))
    return nil
  end
end

M.open_window = function(title, lines)
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- get total dimensions
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  -- calculate our floating window size
  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  -- and its starting position
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  -- set some options
  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  -- Insert contents
  api.nvim_buf_set_lines(buf, 0, 0, true, {title, '(press enter to close)', ''})
  api.nvim_buf_set_lines(buf, 3, 3, true, lines)

  api.nvim_buf_set_keymap(buf, 'n', '<cr>', ':q<cr>', {noremap = true})

  -- create floating window with the buffer attached
  local win = api.nvim_open_win(buf, true, opts)

  return win
end

M.current_word =
    function() return api.nvim_call_function('expand', {'<cword>'}) end

M.global_extend = function(name, values)
  local array = api.nvim_get_var(name)
  if array == nil then
    array = values
  else
    vim.list_extend(array, values)
  end

  api.nvim_set_var(name, array)
end

-- "index" is 1-based
M.buf_get_line = function(buffer, index)
  if index < 1 then
    error('buf_get_line got index ' .. vim.inspect(index) ..
              ', must be 1 or higher')
  end
  return api.nvim_buf_get_lines(buffer, index - 1, index, true)[1]
end

M.restore_cursor = function(buffer, cursor)
  -- row is 1-based
  local row = cursor[1]
  -- col is 0-based
  local col = cursor[2]

  local rows_count = api.nvim_buf_line_count(buffer)
  if row > rows_count then
    row = rows_count - 1
    if row < 1 then row = 1; end
    M.log('[restore_cursor] fixed row to ' .. row)
  end

  local line = M.buf_get_line(buffer, row)
  M.log('[restore_cursor] line #' .. row .. ' = [[[' .. line .. ']]]')
  local col_count = string.len(line)
  M.log('[restore_cursor] line #' .. row .. ' columns = ' .. col_count)
  if col >= col_count then
    if col_count == 0 then
      col = 0
    else
      col = col_count - 1
    end
    M.log('[restore_cursor] fixed column to ' .. col)
  end

  api.nvim_win_set_cursor(buffer, {row, col})
end

M.buf_get_filetype = function(bufnr)
  bufnr = bufnr or 0
  return api.nvim_buf_get_option(bufnr, 'filetype')
end

M.exists = function(expr)
  return api.nvim_eval(string.format('exists("%s")', expr)) ~= 0
end

M.augroup = function(name, content)
  vim.cmd(string.format([[
    augroup Elentok_%s
      autocmd!
      %s
    augroup END
  ]], name, content))
end

return M
