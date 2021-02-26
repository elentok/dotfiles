local api = vim.api

local function safe_require (name)
  local status, module = pcall(require, name)
  if(status) then
    return module
  else
    print(string.format('WARNING: lua module "%s" is missing', name))
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

function create_buf_map_func(bufnr, mode, opts)
  if opts == nil then opts = {} end
  if opts.noremap == nil then opts.noremap = true end
  if opts.silent == nil then opts.silent = true end

  return function(lhs, lua_code)
    local rhs = string.format('<Cmd>lua %s<cr>', lua_code)
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
end

return {
  safe_require = safe_require,
  open_window = open_window,
  current_word = current_word,
  create_buf_map_func = create_buf_map_func,
}

