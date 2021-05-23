local vimp = require('vimp')

-- Move arguments to the left and right (see "AndrewRadev/sideways.vim")
vimp.nnoremap(']m', ':SidewaysRight<cr>')
vimp.nnoremap('[m', ':SidewaysLeft<cr>')
