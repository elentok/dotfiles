local typescript_env = require("elentok.typescript-env")

local ts_server = "vtsls"
if typescript_env.mode == "deno" then ts_server = "denols" end

vim.lsp.enable({ "fish", "lua", ts_server })
