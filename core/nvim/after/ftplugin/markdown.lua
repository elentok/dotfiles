vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.MarkdownFoldExpr(v:lnum)"

vim.keymap.set(
  "n",
  "<leader>js",
  "<Cmd>FzfLua blines query='#'<cr>",
  { desc = "Jump to heading", buffer = 0 }
)
