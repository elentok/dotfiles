local function buf_get_root()
  return vim.fn.systemlist("git-root '" .. vim.fn.expand("%") .. "'")[1]
end

local function cd_to_buf_root()
  local root = buf_get_root()
  vim.cmd("cd " .. root)
  print("Changed directory to: " .. root)
end

local function tab_cd_to_buf_root()
  local root = buf_get_root()
  vim.cmd("tcd " .. root)
  print("Changed tab directory to: " .. root)
end

vim.keymap.set("n", "<Leader>cd", cd_to_buf_root)
vim.keymap.set("n", "<Leader>tcd", tab_cd_to_buf_root)
