vim.keymap.set("n", "<leader>rt", function()
  vim.fn.system(
    "tmux split-window -h 'yt " .. vim.fn.shellescape(vim.fn.expand("%")) .. "; $SHELL'"
  )
end)
