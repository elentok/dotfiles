local create_cmd = vim.api.nvim_create_user_command

create_cmd("W", ":w", {})

create_cmd("DotReload", function()
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

create_cmd("CacheBust", function()
  vim.cmd([[
    LuaCacheClear
    PackerCompile
  ]])
end, {})
