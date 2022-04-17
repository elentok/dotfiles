local util = require("elentok/util")

local config = { enable_tsserver = true, enable_jsts_prettier = true }

local local_config = util.safe_require("elentok-local/config", { silent = true })
if local_config then
  config = vim.tbl_deep_extend("force", config, local_config)
end

return config
