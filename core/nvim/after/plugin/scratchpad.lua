local config = {
  scratchpad_file = function()
    if vim.fn.isdirectory("~/notes/work") then
      return vim.fn.systemlist("weekly-note.ts ~/notes/work")[1]
    else
      return vim.fn.expand("~/notes/home/scratchpad.txt")
    end
  end,
  max_width = 100,
  max_height = 50,
}

local function open()
  local filename = config.scratchpad_file()
  print(filename)
  ---@diagnostic disable-next-line param-type-mismatch
  local bufnr = vim.fn.bufnr(filename)

  if bufnr == -1 then
    bufnr = vim.api.nvim_create_buf(true, false)
  end

  local ui = vim.api.nvim_list_uis()[1]

  local width = math.min(ui.width - 4, config.max_width)
  local height = math.min(ui.height - 4, config.max_height)

  local basename = vim.fn.fnamemodify(filename, ":t")
  local title = string.format("Scratch Pad [%s]", basename)

  local win_handle = vim.api.nvim_open_win(bufnr, true, {
    border = "rounded",
    title = title,
    title_pos = "center",
    width = width,
    height = height,
    relative = "editor",
    col = (ui.width - width) / 2,
    row = (ui.height - height) / 2,
  })
  vim.cmd.e(filename)
  -- vim.keymap.set("n", "q", ":w<cr>:bd<cr>", { buffer = true })
  vim.keymap.set("n", "q", function()
    vim.cmd.w()
    vim.api.nvim_win_hide(win_handle)
  end, { buffer = true })
end

vim.keymap.set("n", "<leader>os", open)
