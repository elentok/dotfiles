require'elentok/packer-bootstrap'
require'elentok/plugins'
require'elentok/lsp'
require'elentok/treesitter'
require'elentok/keys'

local util = require'elentok/util'
util.safe_require('elentok-local')

require('nvim-autopairs').setup()
