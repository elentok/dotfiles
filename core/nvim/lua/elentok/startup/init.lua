vim.g.mapleader = ","

-- Load the runtime before loading the config so it can load the local machine config.
require("elentok/startup/runtimepath")
require("elentok/config")

require("elentok/startup/lazy-bootstrap")
require("lazy").setup("elentok/plugins", {
  concurrency = 10,
})

-- Load the runtime path again because Lazy resets it.
require("elentok/startup/runtimepath")

require("elentok/startup/set")
require("elentok/startup/colors")
require("elentok/startup/statusline")

pcall(require, "elentok-local")
pcall(require, "elentok-private")
