vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("elentok/startup/put")
if not vim.g.vscode then
  require("elentok/startup/lazy")
end
require("elentok/startup/set")

pcall(require, "elentok-private")
