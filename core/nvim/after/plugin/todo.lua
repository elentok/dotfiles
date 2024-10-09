local highlights = require("elentok.todo.highlights")
highlights.create_highlights()

local group_id = vim.api.nvim_create_augroup("Elentok_Markdown", {})
vim.api.nvim_create_autocmd({ "BufRead", "WinNew" }, {
  pattern = "*.md",
  group = group_id,
  callback = function()
    highlights.create_highlight_matchers()
  end,
})
