local function dot_reload()
  for filename in pairs(package.loaded) do
    if filename:match('^elentok') then
      print('Reloading ' .. filename)
      package.loaded[filename] = nil
      require(filename)
    end
  end
end

local function toggle_done()
  local line = vim.fn.getline('.')
  if line:match("✔") then
    line = line:gsub("✔", "☐")
  elseif line:match("☐") then
    line = line:gsub("☐", "✔")
  end
  vim.fn.setline('.', line)
end

vim.cmd([[
  command! DotReload lua require('elentok/commands').dot_reload()
  command! ToggleDone lua require('elentok/commands').toggle_done()
  command! LogEnable lua require('elentok/util').set_log(true)
  command! LogDisable lua require('elentok/util').set_log(false)
]])

return {
  dot_reload = dot_reload,
  toggle_done = toggle_done,
}

