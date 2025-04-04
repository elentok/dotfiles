local ltr_guicursor = vim.opt.guicursor
local rtl_guicursor = vim.opt.guicursor:get()
rtl_guicursor[2] = "i-ci-ver:hor20"

local function toggleHebrew()
  if vim.wo.rightleft then
    vim.opt.guicursor = ltr_guicursor
    vim.wo.rightleft = false
    vim.bo.keymap = nil
  else
    vim.opt.guicursor = rtl_guicursor
    vim.wo.rightleft = true
    vim.bo.keymap = "hebrew"
  end
end

vim.keymap.set("n", "<space>h", toggleHebrew)
