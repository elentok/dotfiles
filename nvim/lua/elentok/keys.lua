local vimp = require('vimp')

-- Move arguments to the left and right (see "AndrewRadev/sideways.vim")
vimp.nnoremap(']m', ':SidewaysRight<cr>')
vimp.nnoremap('[m', ':SidewaysLeft<cr>')

-- Comment/Uncomment via Ctrl-/
vimp.nnoremap('<c-_>', ':Commentary<cr>')
vimp.vnoremap('<c-_>', ':Commentary<cr>')
vimp.inoremap('<c-_>', '<c-o>:Commentary<cr>')
