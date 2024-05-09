local M = {}

local function confirm(question)
  return vim.fn.confirm(question, "&Yes\n&No") == 1
end

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

return { feedkeys = feedkeys, confirm = confirm }
