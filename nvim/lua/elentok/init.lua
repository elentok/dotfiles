require'elentok/packer-bootstrap'
require'elentok/plugins'

require'elentok/commands'
require'elentok/compe'
require'elentok/compe-tab'
require'elentok/format'
require'elentok/keys'
require'elentok/lsp'
require'elentok/statusline'
require'elentok/symbols'
require'elentok/telescope'
require'elentok/todo'
require'elentok/treesitter'

local util = require'elentok/util'
util.safe_require('elentok-local')

require('nvim-autopairs').setup()
