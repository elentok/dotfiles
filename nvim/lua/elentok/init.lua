require'elentok/packer-bootstrap'
require'elentok/plugins'
require'elentok/lsp'
require'elentok/compe'
require'elentok/compe-tab'
require'elentok/treesitter'
require'elentok/keys'
require'elentok/format'
require'elentok/autoformat'
require'elentok/telescope'
require'elentok/statusline'
require'elentok/commands'

local util = require'elentok/util'
util.safe_require('elentok-local')

require('nvim-autopairs').setup()
