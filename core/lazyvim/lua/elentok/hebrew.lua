local ltr_guicursor = vim.opt.guicursor
local rtl_guicursor = vim.opt.guicursor:get()
rtl_guicursor[2] = "i-ci-ver:hor20"

local function enable_hebrew()
  vim.opt.guicursor = rtl_guicursor
  vim.wo.rightleft = true
  vim.wo.spell = false
  vim.bo.keymap = "hebrew"
  vim.b.minipairs_disable = true
  -- jk is too common in hebrew
  vim.keymap.del({ "i" }, "jk")
end

local function disable_hebrew()
  vim.opt.guicursor = ltr_guicursor
  vim.wo.rightleft = false
  vim.wo.spell = true
  vim.bo.keymap = nil
  vim.b.minipairs_disable = false
  vim.keymap.set({ "i" }, "jk", "<esc>")
end

local function toggle_hebrew()
  if vim.wo.rightleft then
    disable_hebrew()
  else
    enable_hebrew()
  end
end

vim.keymap.set("n", "<space>h", toggle_hebrew)
