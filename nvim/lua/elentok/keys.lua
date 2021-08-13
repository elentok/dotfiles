local map = require('elentok/map')

-- Move arguments to the left and right (see "AndrewRadev/sideways.vim")
map.normal(']m', ':SidewaysRight<cr>')
map.normal('[m', ':SidewaysLeft<cr>')

-- Comment/Uncomment via Ctrl-/
map.normal('<c-_>', ':Commentary<cr>')
map.visual('<c-_>', ':Commentary<cr>')
map.insert('<c-_>', '<c-o>:Commentary<cr>')

-- Yank Markdown to HTML
map.visual('<Leader>ym',
           ':!pandoc --from markdown --to html | xclip -selection clipboard -t text/html<cr>u')
map.normal('<Leader>ym',
           ':%!pandoc --from markdown --to html | xclip -selection clipboard -t text/html<cr>u')

-- Signify
map.normal('<Leader>vl', ':SignifyHunkDiff<cr>')
map.normal('<Leader>vt', ':SignifyToggleHighlight<cr>')
