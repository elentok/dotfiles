-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("elentok.log-line")
require("elentok.alternate-file")
require("elentok.git-url")

vim.lsp.inlay_hint.enable(false)
