require "elentok/packer-bootstrap"
require "elentok/packer-plugins"

require "elentok/colors"
require "elentok/format"
require "elentok/statusline"
require "elentok/symbols"
require "elentok/telescope"

local util = require "elentok/util"
util.safe_require("elentok-local", {silent = true})

require("nvim-autopairs").setup()
