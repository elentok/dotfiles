local local_config = vim.fn.expand("~/.dotlocal/nvim")
if vim.fn.isdirectory(local_config) then
  vim.opt.runtimepath:append(local_config)
end

local private_config = vim.fn.expand("~/.dotprivate/nvim")
if vim.fn.isdirectory(private_config) then
  vim.opt.runtimepath:append(private_config)
end
