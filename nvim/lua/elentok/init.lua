require'elentok/packer-bootstrap'
require'elentok/plugins'
require'elentok/lsp'
require'elentok/compe'
require'elentok/compe-tab'
require'elentok/treesitter'
require'elentok/keys'
require'elentok/autoformat'
require'elentok/telescope'
require'elentok/statusline'

local util = require'elentok/util'
util.safe_require('elentok-local')

require('nvim-autopairs').setup()
