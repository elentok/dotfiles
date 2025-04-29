-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("elentok.dotplugins")
require("elentok.put")
require("elentok.slack")
require("elentok.typescript")
if vim.g.neovide then
  require("elentok.neovide")
end

vim.lsp.inlay_hint.enable(false)
