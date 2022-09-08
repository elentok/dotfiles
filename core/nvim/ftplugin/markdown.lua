vim.fn.matchadd("TodoInprogress", "\\[inprogress\\].*$", -1)
vim.fn.matchadd("TodoWaiting", "\\[waiting\\].*$", -1)
vim.fn.matchadd("TodoDone", "\\[x\\].*$", -1)

vim.api.nvim_set_hl(0, "TodoInprogress", { bg = "#EBCB8B", fg = "#000000" })
vim.api.nvim_set_hl(0, "TodoWaiting", { fg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "TodoDone", { fg = "#6C7A96" })
