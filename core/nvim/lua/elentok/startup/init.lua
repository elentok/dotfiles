vim.g.mapleader = ","

require("elentok/startup/lazy-bootstrap")
require("lazy").setup("elentok/plugins")

-- require("elentok/startup/packer")
require("elentok/startup/set")
require("elentok/startup/colors")
require("elentok/startup/statusline")

local util = require("elentok/util")
util.safe_require("elentok-local", { silent = true })
