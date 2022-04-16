local map = require("elentok/map")

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
map.visual("<Leader>m", ":!pandoc --from markdown --to html | copy-html<cr>u")
map.normal("<Leader>m", ":%!pandoc --from markdown --to html | copy-html<cr>u")

-- Signify
map.normal("<Leader>vl", ":SignifyHunkDiff<cr>")
map.normal("<Leader>vt", ":SignifyToggleHighlight<cr>")

-- Misc
map.normal("<Leader>tm", ":set modifiable!<cr>:set modifiable?<cr>")
