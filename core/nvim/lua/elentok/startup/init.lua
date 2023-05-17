vim.g.mapleader = ","

require("elentok/startup/lazy")
require("elentok/startup/set")
require("elentok/startup/colors")
require("elentok/startup/statusline")

pcall(require, "elentok-private")
