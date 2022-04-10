local map = require("elentok/map")

--- Yank Markdown to HTML
map.visual("<Leader>m", ":!pandoc --from markdown --to html | copy-html<cr>u")
map.normal("<Leader>m", ":%!pandoc --from markdown --to html | copy-html<cr>u")

-- Signify
map.normal("<Leader>vl", ":SignifyHunkDiff<cr>")
map.normal("<Leader>vt", ":SignifyToggleHighlight<cr>")

-- Misc
map.normal("<Leader>tm", ":set modifiable!<cr>:set modifiable?<cr>")
