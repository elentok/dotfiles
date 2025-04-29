local dotplugins = {}

if vim.fn.isdirectory(vim.env.DOTP) == 1 then
  for _, plugin in ipairs(vim.fn.readdir(vim.env.DOTP)) do
    local plugindir = vim.env.DOTP .. "/" .. plugin .. "/nvim"
    if vim.fn.isdirectory(plugindir) == 1 then
      table.insert(dotplugins, { dir = plugindir })
    end
  end
end

return dotplugins
