local function close_floating_windows()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format("Closed %d windows: %s", #closed_windows, vim.inspect(closed_windows)))
end

vim.api.nvim_create_user_command("CloseFloats", close_floating_windows, {})
