vim.o.termguicolors = true
vim.o.background = "dark"

local ok, onenord = pcall(require, "onenord")
if not ok then
  return
end

onenord.setup({
  styles = {
    comments = "italic",
  },
  custom_colors = {
    bg = "#232730",
  },
})

----------------------------------------------------
-- Set different background for active windows

vim.cmd([[
  hi NormalNC guibg=#171b20
  hi VertSplit guibg=#171b20
]])

-- Tmux support (requires "focus-events" to be on in tmux.conf)
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  callback = function()
    vim.cmd("hi Normal guibg=#232730")
  end,
})

vim.api.nvim_create_autocmd({ "FocusLost" }, {
  callback = function()
    vim.cmd("hi Normal guibg=#171b20")
  end,
})
