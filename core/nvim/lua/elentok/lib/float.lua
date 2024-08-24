---@class FloatOptions
---@field title string

---@param opts FloatOptions
local function open_float(opts)
  local ui = vim.api.nvim_list_uis()[1]

  opts = vim.tbl_extend("keep", opts, {
    width = ui.width - 6,
    height = ui.height - 6,
  })

  local win_handle = vim.api.nvim_open_win(0, true, {
    border = "rounded",
    title = opts.title,
    title_pos = "center",
    width = opts.width,
    height = opts.height,
    relative = "editor",
    col = (ui.width - opts.width) / 2,
    row = (ui.height - opts.height) / 2,
  })

  return win_handle
end

return { open_float = open_float }
