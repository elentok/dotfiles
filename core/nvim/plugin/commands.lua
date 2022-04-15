vim.api.nvim_create_user_command("W", ":w", {})

vim.api.nvim_create_user_command("DotReload", function()
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
end, {})

function _G.CacheBust()
  vim.cmd([[
    LuaCacheClear
    PackerCompile
  ]])
end

vim.cmd([[
  command! LogEnable lua require('elentok/util').set_log(true)
  command! LogDisable lua require('elentok/util').set_log(false)
  command! CacheBust lua CacheBust()
]])
