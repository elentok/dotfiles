vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("elentok/startup/put")
require("elentok/startup/lazy")
require("elentok/startup/set")

pcall(require, "elentok-private")
