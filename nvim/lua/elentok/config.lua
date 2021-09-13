local util = require("elentok/util")

local config = {enable_tsserver = true}

local local_config = util.safe_require("elentok-local/config")
if local_config then
  config = vim.tbl_deep_extend("force", config, local_config)
end

return config
