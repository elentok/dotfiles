require "elentok/packer-bootstrap"
require "elentok/plugins"

require "elentok/format"
require "elentok/statusline"
require "elentok/symbols"
require "elentok/telescope"

local util = require "elentok/util"
util.safe_require("elentok-local")

require("nvim-autopairs").setup()
