local function messages_buffer()
  local bufnr = vim.fn.bufnr("^Messages$")
  if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.cmd("bd " .. bufnr)
  end

  vim.cmd("new")
  vim.cmd("noswapfile hide enew")
  vim.cmd("put = execute('message')")

  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.modifiable = false
  vim.cmd("file Messages")

  vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>bd<cr>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("Messages", messages_buffer, {})
vim.keymap.set("n", "<c-w>m", messages_buffer)
