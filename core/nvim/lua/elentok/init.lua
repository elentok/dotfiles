require("elentok/packer")

require("elentok/core-settings")
require("elentok/colors")
require("elentok/statusline")
require("elentok/symbols")
require("elentok/telescope")
require("elentok/format-on-save")

local util = require("elentok/util")
util.safe_require("elentok-local", { silent = true })
