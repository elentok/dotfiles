local statusline_shorteners = {}
local statusline_shorteners_updated = false

local M = {}

function M.add_path_shortener(full, short)
  table.insert(statusline_shorteners, {full, short})
  statusline_shorteners_updated = true
end

function M.shorten(path)
  for _, item in ipairs(statusline_shorteners) do
    local full, short = unpack(item)
    path = path:gsub(full .. '/', short .. '/')
    path = path:gsub(full .. '$', short)
  end
  return path
end

function M.filename()
  if vim.b.vaffle ~= nil then
    local short_path = M.shorten(vim.b.vaffle['dir'])
    return 'DIR: ' .. short_path
  end

  -- Temporary solution
  if statusline_shorteners_updated then
    statusline_shorteners_updated = false
    if vim.b.short_path ~= nil then vim.b.short_path = nil end
  end

  local name = vim.fn.expand('%:t')

  if vim.b.short_path == nil then
    vim.b.short_path = M.shorten(vim.fn.expand('%:p:h'))
  end

  return string.format('%s (%s)', name, vim.b.short_path)
end

M.add_path_shortener(vim.env.HOME, '~')

_G.StatusLineFileName = M.filename

vim.o.statusline = table.concat({
  -- Path to the file in the buffer, as typed or relative to current directory.
  '%{v:lua.StatusLineFileName()}', -- Where to truncate line.
  '%< ', '%{&modified?\' +\':\'\'}', '%{&readonly?\' \':\'\'}',
  -- Separation point between left and right aligned items.
  '%= ', -- Filetype.
  ' [%{\'\'!=#&filetype?&filetype:\'none\'}]', -- Line number + column number.
  ' %l:%v'
})

return M
