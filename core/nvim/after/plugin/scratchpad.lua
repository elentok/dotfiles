local config = {
  scratchpad_file = vim.fn.expand("~/notes/home/scratchpad.txt"),
  max_width = 100,
  max_height = 50,
}

local function open()
  local bufnr = vim.fn.bufnr(config.scratchpad_file)

  if bufnr == -1 then
    bufnr = vim.api.nvim_create_buf(true, false)
  end

  local ui = vim.api.nvim_list_uis()[1]

  local width = math.min(ui.width, config.max_width)
  local height = math.min(ui.height, config.max_height)

  vim.api.nvim_open_win(bufnr, true, {
    border = "rounded",
    title = "Scratch Pad",
    title_pos = "center",
    width = width,
    height = height,
    relative = "editor",
    col = (ui.width - width) / 2,
    row = (ui.height - height) / 2,
  })
  vim.cmd.w(config.scratchpad_file)
  vim.keymap.set("n", "q", ":wq<cr>", { buffer = true })
end

vim.keymap.set("n", "<leader>os", open)
