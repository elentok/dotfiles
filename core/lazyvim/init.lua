-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("elentok.dotplugins")
require("elentok.put")

vim.lsp.inlay_hint.enable(false)
