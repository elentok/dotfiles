local statusline_shorteners = {}
local statusline_shorteners_updated = false

local function add_path_shortener(full, short)
  table.insert(statusline_shorteners, {full, short})
  statusline_shorteners_updated = true
end

local function shorten(path)
  for _, item in ipairs(statusline_shorteners) do
    local full, short = unpack(item)
    path = path:gsub(full .. '/', short .. '/')
    path = path:gsub(full .. '$', short)
  end
  return path
end

local function filename()
  if vim.b.vaffle ~= nil then
    local short_path = shorten(vim.b.vaffle['dir'])
    return 'DIR: ' .. short_path
  end

  -- Temporary solution
  if statusline_shorteners_updated then
    statusline_shorteners_updated = false
    if vim.b.short_path ~= nil then vim.b.short_path = nil end
  end

  local name = vim.fn.expand('%:t')

  if vim.b.short_path == nil then
    vim.b.short_path = shorten(vim.fn.expand('%:p:h'))
  end

  return string.format('%s (%s)', name, vim.b.short_path)
end

add_path_shortener(vim.env.HOME, '~')

vim.cmd([[
  function! Elentok_StatusLineFileName()
    return luaeval("require('elentok/statusline').filename()")
  endfunction
]])

vim.o.statusline = table.concat({
  -- Path to the file in the buffer, as typed or relative to current directory.
  '%{Elentok_StatusLineFileName()}', -- Where to truncate line.
  '%< ', '%{&modified?\' +\':\'\'}', '%{&readonly?\' \':\'\'}',
  -- Separation point between left and right aligned items.
  '%= ', -- Filetype.
  ' [%{\'\'!=#&filetype?&filetype:\'none\'}]', -- Line number + column number.
  ' %l:%v'
})

return {
  add_path_shortener = add_path_shortener,
  filename = filename,
  shorten = shorten
}
