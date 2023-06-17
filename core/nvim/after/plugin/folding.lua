vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "getline(v:foldstart)"

-- Deal with issue where folding disappears on save
local group_id = vim.api.nvim_create_augroup("Elentok_Folding", {})

vim.api.nvim_create_autocmd(
  "BufWritePost",
  { group = group_id, pattern = "*", command = "e | normal zv" }
)
