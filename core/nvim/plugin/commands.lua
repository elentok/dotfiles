function _G.DotReload()
  for filename in pairs(package.loaded) do
    if filename:match("^elentok/") then
      -- print('Reloading ' .. filename)
      package.loaded[filename] = nil
      require(filename)
    end
  end

  for filename in pairs(package.loaded) do
    if filename:match("^elentok-local/") then
      -- print('Reloading ' .. filename)
      package.loaded[filename] = nil
      require(filename)
    end
  end
end

function _G.CacheBust()
  vim.cmd([[
    LuaCacheClear
    PackerCompile
  ]])
end

vim.cmd([[
  command! DotReload lua DotReload()
  command! LogEnable lua require('elentok/util').set_log(true)
  command! LogDisable lua require('elentok/util').set_log(false)
  command! CacheBust lua CacheBust()
]])
