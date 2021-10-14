local map = require("elentok/map")

-- Comment/Uncomment via Ctrl-/
map.normal("<c-_>", ":Commentary<cr>")
map.visual("<c-_>", ":Commentary<cr>")
map.insert("<c-_>", "<c-o>:Commentary<cr>")

-- Yank Markdown to HTML
map.visual("<Leader>ym",
           ":!pandoc --from markdown --to html | xclip -selection clipboard -t text/html<cr>u")
map.normal("<Leader>ym",
           ":%!pandoc --from markdown --to html | xclip -selection clipboard -t text/html<cr>u")

-- Signify
map.normal("<Leader>vl", ":SignifyHunkDiff<cr>")
map.normal("<Leader>vt", ":SignifyToggleHighlight<cr>")

-- Misc
map.normal("<Leader>tm", ":set modifiable!<cr>:set modifiable?<cr>")
