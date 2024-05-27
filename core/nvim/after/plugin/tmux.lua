local uv = vim.loop

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    if vim.env.TMUX then
      local cwd = vim.fn.getcwd()
      local dir = "~"
      if cwd ~= uv.os_homedir() then
        dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      end
      vim.fn.system("tmux rename-window " .. dir .. ":", {})
    end
  end,
})
