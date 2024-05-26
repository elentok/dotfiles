local uv = vim.loop

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged", "FocusGained" }, {
  callback = function()
    if vim.env.TMUX then
      vim.fn.system("tmux rename-window vi:" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"), {})
    end
  end,
})
