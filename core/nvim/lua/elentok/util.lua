local api = vim.api

local log_enabled = vim.env.NVIM_LOG == "true"

local M = {}

function M.set_log(enabled)
  log_enabled = enabled
end

function M.log(...)
  if log_enabled then
    put(...)
  end
end

function M.safe_require(name, opts)
  opts = vim.tbl_extend("force", {silent = false}, opts or {})
  local status, module = pcall(require, name)
  if (status) then
    return module
  else
    if not opts.silent then
      print(string.format("WARNING: error loading lua module \"%s\"", name))
    end
    return nil
  end
end

function M.open_window(title, lines)
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(buf, "bufhidden", "wipe")

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
  api.nvim_buf_set_lines(buf, 0, 0, true, {title, "(press enter to close)", ""})
  api.nvim_buf_set_lines(buf, 3, 3, true, lines)

  api.nvim_buf_set_keymap(buf, "n", "<cr>", ":q<cr>", {noremap = true})

  -- create floating window with the buffer attached
  local win = api.nvim_open_win(buf, true, opts)

  return win
end

function M.current_word()
  return api.nvim_call_function("expand", {"<cword>"})
end

function M.global_extend(name, values)
  local array = api.nvim_get_var(name)
  if array == nil then
    array = values
  else
    vim.list_extend(array, values)
  end

  api.nvim_set_var(name, array)
end

-- "index" is 1-based
function M.buf_get_line(buffer, index)
  if index < 1 then
    error("buf_get_line got index " .. vim.inspect(index) ..
              ", must be 1 or higher")
  end
  return api.nvim_buf_get_lines(buffer, index - 1, index, true)[1]
end

function M.buf_get_filetype(bufnr)
  bufnr = bufnr or 0
  return api.nvim_buf_get_option(bufnr, "filetype")
end

function M.exists(expr)
  return api.nvim_eval(string.format("exists(\"%s\")", expr)) ~= 0
end

function M.augroup(name, content)
  vim.cmd(string.format([[
    augroup Elentok_%s
      autocmd!
      %s
    augroup END
  ]], name, content))
end

-- From https://github.com/nanotee/nvim-lua-guide
function M.put(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, " "))
  return ...
end

function M.shell(cmd, opts)
  opts = vim.tbl_extend("force", {stdin = nil, callback = nil, sync = false},
                        opts or {})

  local stderr = nil
  local stdout = nil
  local code = nil

  local job_id = vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stderr = function(_, data, _)
      stderr = data
    end,
    on_stdout = function(_, data, _)
      stdout = data
    end,
    on_exit = function(_, exitcode, _)
      code = exitcode
      if opts.callback then
        opts.callback(exitcode, stdout, stderr)
      end
    end
  })

  if opts.stdin then
    vim.fn.chansend(job_id, opts.stdin)
    vim.fn.chanclose(job_id, "stdin")
  end

  if opts.sync then
    vim.fn.jobwait({job_id})
    return {code = code, stdout = stdout, stderr = stderr}
  else
    return job_id
  end
end

function M.ishell(cmd, opts)
  opts = vim.tbl_extend("force", {large = false}, opts or {})
  local cwd = vim.fn.expand("%:p:h")

  local cmd_args = {
    string.format("cd '%s'", cwd),
    "echo '========================================'",
    string.format("echo '> cd %s'", cwd), string.format("echo '> %s'", cmd),
    "echo '========================================'", cmd
  }

  local size_arg = ""
  if opts.large then
    size_arg = "--width=0.8 --height=0.8"
  end

  local args = {size_arg, table.concat(cmd_args, "&&")}

  local vimcmd = "FloatermNew " .. table.concat(args, " ")
  vim.cmd(vimcmd)
end

function M.tabpage_get_buf_win_number(tabnr, bufnr)
  for _, winhandle in ipairs(api.nvim_tabpage_list_wins(tabnr)) do
    -- winnr = api.nvim_win_get_number(winhandle)
    if bufnr == api.nvim_win_get_buf(winhandle) then
      return api.nvim_win_get_number(winhandle)
    end
  end

  return nil
end
_G.put = M.put

function M.add_dirs(tbl, dirs)
  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      table.insert(tbl, dir)
    end
  end

  return tbl
end

function M.create_scratch_buffer(name, options)
  if options == nil then
    options = {}
  end

  vim.cmd([[
    tabnew
    noswapfile hide enew
  ]])
  vim.cmd("file " .. name)
  if options.text then
    vim.fn.setline(1, options.text)
  end

  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"

  return vim.api.nvim_get_current_buf()
end

return M
