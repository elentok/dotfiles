vim.keymap.set("i", "jk", "<esc>")

vim.keymap.set("n", "<c-s>", ":w<cr>")
vim.keymap.set("i", "<c-s>", "<c-o>:w<cr>")

-- From https://github.com/skwp/dotfiles/blob/master/vim/plugin/settings/stop-visual-paste-insanity.vim:
-- If you visually select something and hit paste that thing gets yanked into
-- your buffer. This generally is annoying when you're copying one item and
-- repeatedly pasting it. This changes the paste command in visual mode so that
-- it doesn't overwrite whatever is in your paste buffer.
vim.keymap.set("v", "p", "\"_dP")

--- Yank Markdown to HTML
vim.keymap.set("v", "<Leader>m",
               ":!pandoc --from markdown --to html | copy-html<cr>u")
vim.keymap.set("n", "<Leader>m",
               ":%!pandoc --from markdown --to html | copy-html<cr>u")

-- Signify
vim.keymap.set("n", "<Leader>vl", ":SignifyHunkDiff<cr>")
vim.keymap.set("n", "<Leader>vt", ":SignifyToggleHighlight<cr>")

-- Misc
vim.keymap.set("n", "<Leader>tm", ":set modifiable!<cr>:set modifiable?<cr>")
vim.keymap.set("n", "_", ":Vifm<cr>")
