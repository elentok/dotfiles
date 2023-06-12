local function toggle_focused_test()
  local line = vim.api.nvim_get_current_line()

  if line:match("%f[%a]describe%(") then
    line = line:gsub("%f[%a]describe%(", "describe.only(")
  elseif line:match("%f[%a]describe.only%(") then
    line = line:gsub("%f[%a]describe.only%(", "describe(")
  elseif line:match("%f[%a]it%(") then
    line = line:gsub("%f[%a]it%(", "it.only(")
  elseif line:match("%f[%a]it.only%(") then
    line = line:gsub("%f[%a]it.only%(", "it(")
  end

  vim.api.nvim_set_current_line(line)
end

vim.keymap.set("n", "<space>tt", toggle_focused_test)
