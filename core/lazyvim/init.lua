-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("elentok.log-line")
require("elentok.dotplugins")

vim.lsp.inlay_hint.enable(false)
