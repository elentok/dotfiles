local api = vim.api

local function safe_require (name)
  local status, module = pcall(require, name)
  if(status) then
    return module
  else
    print(string.format('WARNING: error loading lua module "%s"', name))
    return nil
  end
end

local function open_window(title, lines)
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
    col = col,
  }

  -- Insert contents
  api.nvim_buf_set_lines(buf, 0, 0, true, {title, '(press enter to close)', ''})
  api.nvim_buf_set_lines(buf, 3, 3, true, lines)

  api.nvim_buf_set_keymap(buf, 'n', '<cr>', ':q<cr>', {noremap = true})

  -- create floating window with the buffer attached
  local win = api.nvim_open_win(buf, true, opts)

  return win
end

local function current_word()
  return api.nvim_call_function('expand', {'<cword>'})
end

local function global_extend(name, values)
  array = api.nvim_get_var(name)
  if array == nil then
    array = values
  else
    vim.list_extend(array, values)
  end

  api.nvim_set_var(name, array)
end

local function restore_cursor(buffer, cursor)
  rows_count = api.nvim_buf_line_count(buffer)
  row = cursor[1]
  if row >= rows_count then
    row = rows_count - 1
  end

  col = cursor[2]
  line = api.nvim_buf_get_lines(buffer, row - 1, row, true)[1]
  col_count = string.len(line)
  if col >= col_count then
    col = col_count - 1
  end

  api.nvim_win_set_cursor(buffer, {row, col})
end

function buf_get_filetype(bufnr)
  bufnr = bufnr or 0
  return api.nvim_buf_get_option(bufnr, 'filetype')
end

function create_map_func(mode, opts)
  if opts == nil then opts = {} end
  if opts.noremap == nil then opts.noremap = true end
  if opts.silent == nil then opts.silent = true end

  return function(lhs, lua_code)
    local rhs = string.format('<Cmd>lua %s<cr>', lua_code)
    api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

function create_buf_map_func(bufnr, mode, opts)
  if opts == nil then opts = {} end
  if opts.noremap == nil then opts.noremap = true end
  if opts.silent == nil then opts.silent = true end

  return function(lhs, lua_code)
    local rhs = string.format('<Cmd>lua %s<cr>', lua_code)
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
end

function exists (expr)
  return api.nvim_eval(string.format('exists("%s")', expr)) ~= 0
end

return {
  buf_get_filetype = buf_get_filetype,
  create_map_func = create_map_func,
  create_buf_map_func = create_buf_map_func,
  current_word = current_word,
  exists = exists,
  global_extend = global_extend,
  open_window = open_window,
  restore_cursor = restore_cursor,
  safe_require = safe_require,
}

