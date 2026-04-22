vim.keymap.set("n", "q", "<Cmd>q<cr>")
vim.keymap.set("n", "vv", "V")
vim.keymap.set("n", "vc", "<c-v>")
vim.keymap.set("n", "gl", "$")
vim.keymap.set("n", "ge", "G")
vim.keymap.set("n", "yl", "0vg_y")
vim.keymap.set("v", "y", "y:q<cr>")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.clipboard = { "unnamed", "unnamedplus" }
vim.opt.laststatus = 0
vim.opt.cmdheight = 0

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

local function scroll(lines)
  local view = vim.fn.winsaveview()
  local last = vim.api.nvim_buf_line_count(0)
  view.topline = math.min(view.topline + lines, last)
  vim.fn.winrestview(view)
end

local function jump_to_line()
  local input_line = tonumber(vim.env.INPUT_LINE_NUMBER, 10)
  local cursor_line = tonumber(vim.env.CURSOR_LINE, 10)
  local cursor_column = tonumber(vim.env.CURSOR_COLUMN, 10)
  local line = vim.fn.max({ 0, input_line - 1 }) + cursor_line

  vim.defer_fn(function()
    vim.fn.cursor(line, cursor_column)
    vim.defer_fn(function() scroll(-1) end, 10)
  end, 50)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.env.INPUT_LINE_NUMBER ~= nil and vim.env.INPUT_LINE_NUMBER ~= "" then
      jump_to_line()
    else
      vim.cmd("normal G")
    end
  end,
})
