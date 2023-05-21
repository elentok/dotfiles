local create_cmd = vim.api.nvim_create_user_command
local util = require("elentok/util")

create_cmd("W", ":w", {})
create_cmd("SudoWrite", ":w !sudo tee %", {})

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
  ]])
end, {})

create_cmd("TermNewTab", function(args)
  util.terminal_in_new_tab(args.args)
end, { nargs = "+", desc = "Runs a shell command in a new tab terminal" })

create_cmd("Markserv", function(args)
  util.terminal_in_new_tab("markserv")
  vim.cmd("tabprevious")
  vim.cmd('silent !o "http://localhost:8642/%"')
end, {})

create_cmd("PreviewSassColors", "!preview_sass_colors % && open preview.html", {})
