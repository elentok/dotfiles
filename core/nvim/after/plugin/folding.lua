-- vim.opt.foldlevel = 20
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldtext = "getline(v:foldstart)"
--
-- -- Deal with issue where folding disappears on save
-- local group_id = vim.api.nvim_create_augroup("Elentok_Folding", {})
--
-- vim.api.nvim_create_autocmd(
--   "BufWritePost",
--   { group = group_id, pattern = "*", command = "e | normal zv" }
-- )

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
vim.opt.foldtext = "getline(v:foldstart)"
