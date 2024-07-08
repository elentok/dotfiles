local create_cmd = vim.api.nvim_create_user_command
local util = require("elentok/util")
local ui = require("elentok.lib.ui")
local terminal = require("elentok.lib.terminal")

create_cmd("W", ":w", {})
create_cmd("SudoWrite", ":w !sudo tee %", {})

create_cmd("Delete", function()
  if not ui.confirm("Delete " .. vim.fn.expand("%:t")) then
    return
  end

  local filename = vim.fn.expand("%")
  local result = vim.system({ "rm", filename }):wait()
  if result.code ~= 0 then
    vim.notify("Error deleting " .. filename)
    return
  end

  vim.api.nvim_buf_delete(0, { froce = true })
end, {})

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

create_cmd("Vifm", function()
  terminal.run("vifm --select " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, {})

create_cmd("Markserv", function(args)
  util.terminal_in_new_tab("markserv")
  vim.cmd("tabprevious")
  vim.cmd('silent !o "http://localhost:8642/%"')
end, {})

create_cmd("PreviewSassColors", "!preview_sass_colors % && open preview.html", {})

create_cmd("RemoveWhitespace", ":%s/\\s\\+$//", {})
