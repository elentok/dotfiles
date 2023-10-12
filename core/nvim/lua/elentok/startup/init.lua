vim.g.mapleader = ","

require("elentok/startup/put")
require("elentok/startup/lazy")
require("elentok/startup/set")

pcall(require, "elentok-private")
