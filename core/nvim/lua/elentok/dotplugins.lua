local root = vim.uv.os_homedir() .. "/.dotplugins"

for _, plugin in ipairs(vim.fn.readdir(root)) do
  local plugindir = root .. "/" .. plugin .. "/nvim"
  if vim.fn.isdirectory(plugindir) == 1 then
    vim.opt.rtp:append(plugindir)
    require(plugin)
  end
end
