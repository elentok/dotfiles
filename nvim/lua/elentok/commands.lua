local function dot_reload()
  for filename in pairs(package.loaded) do
    if filename:match('^elentok') then
      print('Reloading ' .. filename)
      package.loaded[filename] = nil
      require(filename)
    end
  end
end

vim.cmd([[
  command! DotReload lua require('elentok/commands').dot_reload()
]])

return {
  dot_reload = dot_reload,
}

