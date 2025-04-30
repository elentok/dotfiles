require("config.settings")
require("config.lazy")
require("config.keymaps")
require("config.lsp")

require("elentok.dotplugins")
require("elentok.slack")
if vim.g.neovide then require("elentok.neovide") end
